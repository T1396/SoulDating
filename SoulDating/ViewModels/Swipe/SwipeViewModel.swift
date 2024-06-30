//
//  SwipeViewModel.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 11.06.24.
//

import Foundation
import Combine
import Firebase
import MapKit

class SwipeViewModel: BaseAlertViewModel, SwipeUserDelegate {

    
    
    var objectWillChange = PassthroughSubject<Void, Never>()

    private let firebaseManager = FirebaseManager.shared
    internal let rangeManager = RangeManager()
    private var isInitialized = false
    
    @Published var noMoreUsersAvailable = false
    @Published var allSwipeableUs: [SwipeUserViewModel] = [] {
        didSet {
            if allSwipeableUs.isEmpty && !noMoreUsersAvailable {
                fetchUsersNearby()
            }
        }
    }
    @Published var user: User {
        didSet {
            fetchUsersNearby()
        }
    }
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: init
    init(user: User) {
        self.user = user
        super.init()
    }
    
    
    // MARK: computed properties
    var userId: String {
        user.id
    }
    
    
    
    // MARK: functions
    
    /// delegate function, gets called from swipeViewModels when user swiped another user to remove him from the list
    func userDidSwipe(_ userId: String) {
        print("called")
        removeUser(userId)
    }
    
    func removeUser(_ userId: String) {
        if let index = allSwipeableUs.firstIndex(where: { $0.otherUser.id == userId }) {
            print("removed \(allSwipeableUs[index].otherUser.name)")
            allSwipeableUs.remove(at: index)
        }
    }
}

// MARK: user synchronization
extension SwipeViewModel {
    /// gets called when swipeView is shown, updates the actual user when e.g. changed to the radius has been made
    ///  and created a subscription
    func configure(with userViewModel: UserViewModel) {
        if !isInitialized {
            // create subscription to user data
            userViewModel.$user
                .compactMap { $0 }
                .sink { [weak self] newUser in
                    self?.user = newUser
                }
                .store(in: &cancellables)
            isInitialized = true
        }
    }
}


// MARK: range fetch
extension SwipeViewModel {
    func fetchUsersNearby() {
        print("started fetched users nearby")
        guard let userId = firebaseManager.userId else { return }
        
        let relationshipRef = firebaseManager.database.collection("user_relationships")
        let queryInteraction = relationshipRef.whereField("userId", isEqualTo: userId)
        
        // fetch all userIds the actual user has liked/disliked already to  exclude them
        queryInteraction.getDocuments { [weak self] (snapshot, error) in
            guard let documents = snapshot?.documents else {
                print("Error fetching interactions: \(error?.localizedDescription ?? "unknown error")")
                return
            }
            var excludedUserIds = documents.compactMap { $0.data()["targetUserId"] as? String }
            excludedUserIds.append(userId)
            excludedUserIds.append(contentsOf: self?.user.blockedUsers ?? [])
            self?.queryUsersNearby(excluding: excludedUserIds, ownLocation: self?.user.location ?? LocationPreference())
        }
    }

    
    func queryUsersNearby(
        excluding excludedUserIds: [String],
        ownLocation: LocationPreference
    ) {
        let usersRef = firebaseManager.database.collection("users")
        // calculate lat and longitude corresponding to radius
        // builds a square area range query that needs to be filtered further
        let rangeQuery = rangeManager.buildRangeQuery(collectionRef: usersRef, excluding: excludedUserIds, location: ownLocation)
    
        rangeQuery.getDocuments { docSnapshot, error in
            if let error {
                print("Error fetching Users nearby", error.localizedDescription)
                self.createAlert(title: "Error!", message: "An error occured while fetching new people for you...")
                return
            }
            guard let docSnapshot else {
                return
            }
            
            if docSnapshot.documents.isEmpty {
                self.noMoreUsersAvailable = true
            } else {
                
                let filteredUsers = docSnapshot.documents.compactMap { document -> User? in
                    do {
                        let user = try document.data(as: User.self)
                        // skip users where location possibly does not exist
                        return self.rangeManager.checkForDistance(user.location, ownLocation) ? user : nil
                    } catch {
                        // decoding error
                        print("There was an error while decoding a user document", error.localizedDescription)
                        return nil
                    }
                }
                self.noMoreUsersAvailable = filteredUsers.isEmpty
                self.allSwipeableUs = filteredUsers.map {
                    let viewModel = SwipeUserViewModel(currentUserId: self.user.id, otherUser: $0, currentLocation: ownLocation)
                    viewModel.delegate = self
                    return viewModel
                }
            }
        }
    }
}

// MARK: error messages / alert functions
extension SwipeViewModel {
    
}
