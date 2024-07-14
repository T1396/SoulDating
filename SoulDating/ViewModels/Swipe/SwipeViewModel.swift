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
import CoreData

class SwipeViewModel: BaseAlertViewModel, SwipeUserDelegate {
    // MARK: properties
    private let firebaseManager = FirebaseManager.shared
    private let rangeManager = RangeManager.shared
    private let userService: UserService
    private (set) var user: FireUser
    private var cancellables = Set<AnyCancellable>()

    private var userLikes: [String] = [] // to show matches
    private var likesListener: ListenerRegistration?
    private var removedUsers: [FireUser] = []
    private var lastDocumentSnapshot: DocumentSnapshot?

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
        self.fetchUsersNearby()
    }

    // MARK: functions
    private func updateDisplayedUsers() {
        if displayedUsers.count < 3 {
            refillDisplayedUsers()
        }
    }

    private func refillDisplayedUsers() {
        while displayedUsers.count < 3 && !allSwipeableUsers.isEmpty {
            let userToAdd = allSwipeableUsers.removeFirst()
            displayedUsers.append(userToAdd)
        }

        if displayedUsers.isEmpty && allSwipeableUsers.isEmpty {
            fetchUsersNearby()
        }
    }


    func subscribe() {
        setUserLikesListener()
        let oldUser = self.user
        self.user = userService.user
        if user.hasRelevantDataChangesToRefetch(from: oldUser) {
            // reset the last doc snapshot from where the query begins to search because otherwise
            // users could be skipped due to the sorting after registration date
            lastDocumentSnapshot = nil
            fetchUsersNearby()
        }
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
        // save last swiped user to querie after that in future
        if action == .like {
            if userLikes.contains(where: { $0 == userId }) {
                withAnimation {
                    userMatch = removedUser
                }
            }
        }
        updateDisplayedUsers()
    }
    /// delegate function when in swipeUserViewModel / ReportViewModel user was reported to remove him from the list
    internal func userDidReport(_ userId: String) {
        removeUser(userId)
        updateDisplayedUsers()
    }


    @discardableResult
    private func removeUser(_ userId: String) -> FireUser? {
        if let index = displayedUsers.firstIndex(where: { $0.otherUser.id == userId }) {
            let removed = displayedUsers.remove(at: index)
            removedUsers.append(removed.otherUser)
            return removed.otherUser
        }
        return nil
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
            }
    }
}


// MARK: range fetch
extension SwipeViewModel {
    func fetchUsersNearby() {
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
            excludedUserIds.append(contentsOf: self?.userService.user.blockedUsers ?? [])
            self?.queryUsersNearby(userId: userId, excluding: excludedUserIds)
        }
    }

    private func queryUsersNearby(userId: String, excluding excludedUserIds: [String]) {
        let usersRef = firebaseManager.database.collection("users")
        // builds a square area range query that needs to be filtered further
        var query = rangeManager.buildRangeQuery(collectionRef: usersRef, excluding: userId, location: user.location)
        query = query
            .order(by: "registrationDate")
            .whereField("isHidden", isEqualTo: false)
        // if there is a last swiped userdoc start querying after this user so that already swiped users wont get fetched
        if let lastDocumentSnapshot {
            query = query.start(afterDocument: lastDocumentSnapshot)
        }
        executeQuery(query: query, excludedUserIds: excludedUserIds)
    }

    private func executeQuery(query: Query, excludedUserIds: [String]) {
        // firebase queries doesnt allow notIn + in filters so gender must be checked afterwards
        let preferredGenders = user.preferences.gender ?? Gender.allCases
        query.getDocuments { docSnapshot, error in
            if let error {
                print("Error fetching Users nearby", error.localizedDescription)
                self.createFailedFetchAlert()
                return
            }
            guard let docSnapshot else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.isFetchingUsers = false
                }
                return
            }

            if docSnapshot.documents.isEmpty {
                self.noMoreUsersAvailable = true
            } else {
                let filteredUsers = docSnapshot.documents.compactMap { document -> FireUser? in
                    do {
                        let target = try document.data(as: FireUser.self)
                        let isValid = self.filterUser(target: target, excluded: excludedUserIds, preferredGenders: preferredGenders)
                        return isValid ? target : nil
                    } catch {
                        print("There was an error while decoding a user document", error.localizedDescription)
                        return nil
                    }
                }
                self.lastDocumentSnapshot = docSnapshot.documents.last
                self.noMoreUsersAvailable = filteredUsers.isEmpty
                self.allSwipeableUsers = filteredUsers.map {
                    let viewModel = SwipeUserViewModel(otherUser: $0)
                    viewModel.delegate = self
                    return viewModel
                }
                self.updateDisplayedUsers()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.isFetchingUsers = false
            }
        }
    }
    
    /// checks if a fetched user matches distance, gender and is not excluded
    private func filterUser(target: FireUser, excluded: [String], preferredGenders: [Gender]) -> Bool {
        let isNotExcluded = !excluded.contains(where: { $0 == target.id })
        let isPrefGender = checkForPrefGender(target, preferredGenders: preferredGenders)
        return isNotExcluded && isPrefGender && rangeManager.checkForDistance(target.location, user.location)
    }

    /// checks if a fetched user matches the currentUsers gender preference, returns true if so, false otherwise
    private func checkForPrefGender(_ user: FireUser, preferredGenders: [Gender]) -> Bool {
        preferredGenders.contains(where: { $0.rawValue == user.gender?.rawValue })
    }

    /// sets attributes to show alert in a view with onAccept beeing a closure to call when e.g. retry in the alert is pressed, in this case retry button
    /// will fetch users again
    private func createFailedFetchAlert() {
        self.createAlert(title: "Error", message: Strings.fetchSwipeError, onAccept: self.fetchUsersNearby)
    }
}
