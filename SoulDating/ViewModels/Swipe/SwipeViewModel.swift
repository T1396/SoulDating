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

class SwipeViewModel: BaseAlertViewModel {
    private let firebaseManager = FirebaseManager.shared
    private let rangeManager = RangeManager()
    private var isInitialized = false
    
    @Published var errorMessage: String?
    @Published var noMoreUsersAvailable = false
    @Published var allSwipeableUsers: [User] = [] {
        didSet {
            if allSwipeableUsers.isEmpty && !noMoreUsersAvailable{
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
    }
    
    // MARK: computed properties
    var userId: String {
        user.id
    }
    
    // MARK: functions
    func removeUser(_ user: User) {
        if let index = allSwipeableUsers.firstIndex(where: { $0.id == user.id }) {
            print("removed \(user.name ?? "")")
            allSwipeableUsers.remove(at: index)
        }
    }
    
    func distance(to user: User) -> String? {
        rangeManager.returnDistance(from: self.user, to: user)
    }
    
    /// Sets a like dislike  or superlike after a swipe and updates it to firestore
    func setActionAfterSwipe(_ action: SwipeAction, for targetUserId: String) {
        guard let userId = firebaseManager.userId else { return }
        
        let db = firebaseManager.database
        let swipeActionDict = returnActionDict(action, targetUserId: targetUserId)
        let targetUserLikesDict = returnActionDict(action)
        let userActionRef = db.collection("userActions").document(userId)
        let targetUserLikesRef = db.collection("userLikes").document(targetUserId)
            .collection(action.rawValue).document()
        
        firebaseManager.database.runTransaction { transaction, errorpointer in
            
            transaction.setData(swipeActionDict, forDocument: userActionRef)
            transaction.setData(targetUserLikesDict, forDocument: targetUserLikesRef)
            return nil
            
        } completion: { object, error in
            if let error {
                print("Error saving user interaction \(action.rawValue)", error.localizedDescription)
                
            }
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

extension SwipeViewModel {
    // get dict to save action to own user document
    func returnActionDict(_ action: SwipeAction, targetUserId: String) -> [String: Any] {
        let dict: [String: Any] = [
            "userId": userId,
            "targetUserId": targetUserId,
            "action": action.rawValue,
            "timestamp": FieldValue.serverTimestamp()
        ]
        return dict
    }
    // get dict to save into target users likes collection
    func returnActionDict(_ action: SwipeAction) -> [String: Any] {
        let dict: [String: Any] = [
            "fromUserId": userId,
            "action": action.rawValue,
            "timestamp": FieldValue.serverTimestamp()
        ]
        return dict
    }
}

// MARK: range fetch
extension SwipeViewModel {
    func fetchUsersNearby() {
        print("started fetched users nearby")
        guard let userId = firebaseManager.userId, let location = user.location else { return }
        
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
            self?.queryUsersNearby(excluding: excludedUserIds, ownLocation: location)
        }
    }

    
    func queryUsersNearby(
        excluding excludedUserIds: [String],
        ownLocation: LocationPreference
    ) {
        let usersRef = firebaseManager.database.collection("users")
        // calculate lat and longitude corresponding to radius
        let rangeQuery = rangeManager.buildRangeQuery(collectionRef: usersRef, excluding: excludedUserIds, location: ownLocation)
    
        rangeQuery.getDocuments { docSnapshot, error in
            if let error {
                print("Error fetching Users nearby", error.localizedDescription)
                self.errorMessage = "An error occured while fetching for new people..."
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
                        guard let targetLocation = user.location else { return nil }
                        return self.rangeManager.checkForDistance(targetLocation, ownLocation) ? user : nil
                    } catch {
                        // decoding error
                        print("There was an error while decoding a user document", error.localizedDescription)
                        return nil
                    }
                }
                self.noMoreUsersAvailable = filteredUsers.isEmpty
                self.allSwipeableUsers = filteredUsers
            }
        }
    }
}

// MARK: error messages / alert functions
extension SwipeViewModel {
    func createFailedActionAlert(_ action: SwipeAction) {
        createAlert(
            title: "Oops, an error occured.",
            message: "We could not save your \(action.title). Please retry or submit a bug report."
        )
    }
}
