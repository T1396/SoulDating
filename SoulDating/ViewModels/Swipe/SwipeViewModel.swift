//
//  SwipeViewModel.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 11.06.24.
//

import SwiftUI
import Foundation
import Combine
import Firebase
import MapKit

class SwipeViewModel: BaseAlertViewModel, SwipeUserDelegate {
    
    private let firebaseManager = FirebaseManager.shared
    private let rangeManager = RangeManager()
    private let userService: UserService
    private var user: FireUser
    private var cancellables = Set<AnyCancellable>()
    private var userLikes: [String] = []
    private var likesListener: ListenerRegistration?
    private var removedUsers: [FireUser] = []

    @Published private(set) var displayedUsers: [SwipeUserViewModel] = []
    @Published private(set) var noMoreUsersAvailable = false
    @Published private(set) var isFetchingUsers = false
    private var allSwipeableUsers: [SwipeUserViewModel] = []
    @Published var userMatch: FireUser?

    // MARK: init
    init(userService: UserService = .shared) {
        self.userService = userService
        self.user = userService.user
        super.init()
    }
    
    // MARK: functions
    private func updateDisplayedUsers() {
        if displayedUsers.count < 2 {
            refillDisplayedUsers()
        }
    }

    private func refillDisplayedUsers() {
        while displayedUsers.count < 2 && !allSwipeableUsers.isEmpty {
            let userToAdd = allSwipeableUsers.removeFirst()
            displayedUsers.append(userToAdd)
        }

        if displayedUsers.isEmpty && allSwipeableUsers.isEmpty {
            fetchUsersNearby()
        }
    }


    func subscribe() {
        print("CALLED FORM SUBSCRIPE FETCH USERS NEARBY")
        fetchUsersNearby()
        setUserLikesListener()
        userService.$user
            .compactMap { $0 }
            .sink { [weak self] user in
                self?.user = user
                if let changed = self?.didValuesChange(user: user), changed {
                    print("CALLED FROM SUBSCRIPTION FETCH USERS NEARBY")
                    self?.fetchUsersNearby()
                }
            }
            .store(in: &cancellables)
    }

    func unsubscribe() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        likesListener?.remove()
        likesListener = nil
    }
    
    /// delegate function, gets called from swipeViewModels when user swiped another user to remove him from the list
    internal func userDidSwipe(_ userId: String, action: SwipeAction) {
        let removedUser = removeUser(userId)
        if action == .like {
            if userLikes.contains(where: { $0 == userId }) {
                withAnimation {
                    userMatch = removedUser
                }
            }
        }
    }
    /// delegate function when in swipeUserViewModel / ReportViewModel user was reported to remove him from the list
    internal func userDidReport(_ userId: String) {
        removeUser(userId)
    }
    
    @discardableResult
    private func removeUser(_ userId: String) -> FireUser? {
        if let index = displayedUsers.firstIndex(where: { $0.otherUser.id == userId }) {
            let removed = displayedUsers.remove(at: index)
            removedUsers.append(removed.otherUser)
            refillDisplayedUsers()
            return removed.otherUser
        }
        return nil
    }
    
    private func didValuesChange(user: FireUser) -> Bool {
        locationChanged(user.location) ||
        ageRangeChanged(user.preferences.agePreferences) ||
        genderPrefChanges(user.preferences.gender)
    }

    private func locationChanged(_ location: LocationPreference) -> Bool {
        user.location != location
    }

    private func ageRangeChanged(_ agePreference: AgePreference?) -> Bool {
        user.preferences.agePreferences != agePreference
    }

    private func genderPrefChanges(_ genders: [Gender]?) -> Bool {
        user.preferences.gender != genders
    }
}

// MARK: LIKES LISTENER
extension SwipeViewModel {
    /// fetches the userIds who liked the current user to show matches when user liked anotherone that liked him too
    private func setUserLikesListener() {
        likesListener = firebaseManager.database.collection("userLikes").document(user.id)
            .collection("like")
            .addSnapshotListener { querySnapshot, error in
                if let error {
                    print("Error fetching likes", error.localizedDescription)
                    return
                }
                self.userLikes = querySnapshot?.documents.compactMap { doc in
                    doc.data()["fromUserId"] as? String
                } ?? []
                print("USERLIKES: \(self.userLikes)")
            }
    }
}


// MARK: range fetch
extension SwipeViewModel {
    func fetchUsersNearby() {
        print("started fetched users nearby")
        guard let userId = firebaseManager.userId else { return }
        isFetchingUsers = true
        let relationshipRef = firebaseManager.database.collection("userActions").document(userId).collection("actions")
        let queryInteraction = relationshipRef.whereField("fromUserId", isEqualTo: userId)
        
        // fetch all userIds the actual user has liked/disliked already to  exclude them
        queryInteraction.getDocuments { [weak self] snapshot, error in
            guard let documents = snapshot?.documents else {
                print("Error fetching interactions: \(error?.localizedDescription ?? "unknown error")")
                self?.isFetchingUsers = false
                return
            }
            var excludedUserIds = documents.compactMap { $0.data()["targetUserId"] as? String }
            excludedUserIds.append(userId)
            excludedUserIds.append(contentsOf: self?.userService.user.blockedUsers ?? [])
            print("EXCLUDED USERS: \(excludedUserIds)")
            self?.queryUsersNearby(excluding: excludedUserIds, ownLocation: self?.user.location ?? LocationPreference())
        }
    }

    
    private func queryUsersNearby(
        excluding excludedUserIds: [String],
        ownLocation: LocationPreference
    ) {
        let usersRef = firebaseManager.database.collection("users")
        // calculate lat and longitude corresponding to radius
        // builds a square area range query that needs to be filtered further
        let rangeQuery = rangeManager.buildRangeQuery(collectionRef: usersRef, excluding: excludedUserIds, location: ownLocation)
        // firebase queries doesnt allow notIn + in filters so gender must be checked afterwards
        let preferredGenders = user.preferences.gender ?? Gender.allCases

        rangeQuery.getDocuments { docSnapshot, error in
            if let error {
                print("Error fetching Users nearby", error.localizedDescription)
                self.createFailedFetchAlert()
                return
            }
            guard let docSnapshot else {
                self.executeDelayed(completion: {
                    self.isFetchingUsers = false
                }, delay: 1.5)
                return
            }
            
            if docSnapshot.documents.isEmpty {
                self.noMoreUsersAvailable = true
            } else {
                let filteredUsers = docSnapshot.documents.compactMap { document -> FireUser? in
                    do {
                        let user = try document.data(as: FireUser.self)
                        let isInDistance = self.rangeManager.checkForDistance(user.location, ownLocation)
                        let isPreferredGender = self.checkForPrefGender(user, preferredGenders: preferredGenders)
                        return isInDistance && isPreferredGender ? user : nil
                    } catch {
                        // decoding error
                        print("There was an error while decoding a user document", error.localizedDescription)
                        return nil
                    }
                }
                self.noMoreUsersAvailable = filteredUsers.isEmpty
                self.allSwipeableUsers = filteredUsers.map {
                    let viewModel = SwipeUserViewModel(otherUser: $0)
                    viewModel.delegate = self
                    return viewModel
                }
                print("ALL FETCHED SWIPEABLE USERS FILTERED: \(self.allSwipeableUsers.map { $0.otherUser.name })")
                self.updateDisplayedUsers()
            }
            self.executeDelayed(completion: {
                self.isFetchingUsers = false
            }, delay: 1.5)
        }
    }

    /// checks if a fetched user matches the currentUsers gender preference, returns true if so, false otherwise
    private func checkForPrefGender(_ user: FireUser, preferredGenders: [Gender]) -> Bool {
        preferredGenders.contains(where: { $0.rawValue == user.gender?.rawValue })
    }
    
    /// sets attributes to show alert in a view with onAccept beeing a closure to call when e.g. retry in the alert is pressed
    private func createFailedFetchAlert() {
        self.createAlert(title: "Error", message: "An error occured while fetching new people for you...", onAccept: self.fetchUsersNearby)
    }
}
