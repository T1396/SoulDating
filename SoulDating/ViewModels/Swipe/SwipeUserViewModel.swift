//
//  SwipeUserViewModel.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 21.06.24.
//

import Foundation
import Firebase

protocol SwipeUserDelegate: AnyObject {
    func userDidSwipe(_ userId: String)
}

class SwipeUserViewModel: BaseAlertViewModel, Identifiable, RangeCalculating {
    func distance(to targetLocation: LocationPreference) -> String? {
        return rangeManager.distanceString(from: currentLocation, to: targetLocation)
    }
    
    weak var delegate: SwipeUserDelegate?
    
    private let TAG = "(SwipeUserViewModel)"
    private let firebaseManager = FirebaseManager.shared
    @Published var otherUser: User
    let currentUserId: String
    private let currentLocation: LocationPreference
    internal let rangeManager = RangeManager()
    
    var isNewUser: Bool {
        if let date = otherUser.registrationDate, !date.isOlderThan30Days {
            return true
        } else {
            return false
        }
    }
    
    init(currentUserId: String, otherUser: User, currentLocation: LocationPreference) {
        self.currentUserId = currentUserId
        self.otherUser = otherUser
        self.currentLocation = currentLocation
    }
    
    func removeUser() {
        // send notification with delegate to remove swiped user from the list in swipeListViewModel
        DispatchQueue.main.async {
            print("removed user outer viewmodel")
            self.delegate?.userDidSwipe(self.otherUser.id)
        }
    }
}

extension SwipeUserViewModel {
    var distance: String? {
        return rangeManager.distanceString(from: currentLocation, to: otherUser.location)
    }
    
    /// Sets a like dislike  or superlike after a swipe and updates it to firestore,
    /// sets one document for the current user where all likes of himself are saved
    /// sets another document for the targetUser so all likes can be accessed easier in e.g. LikesView
    func setActionAfterSwipe(_ action: SwipeAction) {
        guard let userId = firebaseManager.userId else { return }
        
        let db = firebaseManager.database
        let swipe = Swipe(fromUserId: currentUserId, targetUserId: otherUser.id, action: action, timestamp: .now)
        let targetUserSwipe = UserSwipe(action: action, fromUserId: currentUserId, timestamp: .now)
        let userActionRef = db.collection("userActions").document(userId)
        let targetUserLikesRef = db.collection("userLikes").document(otherUser.id)
            .collection(action.rawValue).document()
        
        firebaseManager.database.runTransaction { transaction, errorpointer in
            do {
                try transaction.setData(from: swipe, forDocument: userActionRef)
                try transaction.setData(from: targetUserSwipe, forDocument: targetUserLikesRef)
            } catch {
                print("\(self.TAG) Error encoding swipe/ userSwipe struct", error.localizedDescription)
            }
            return nil
            
        } completion: { object, error in
            if let error {
                print("Error saving user interaction \(action.rawValue)", error.localizedDescription)
            }
            
            // send notification with delegate to remove swiped user from the list in swipeListViewModel
            DispatchQueue.main.async {
                self.delegate?.userDidSwipe(self.otherUser.id)
            }
        }
    }
}

// MARK: alert
extension SwipeUserViewModel {
    func createFailedActionAlert(_ action: SwipeAction) {
        createAlert(
            title: "Oops, an error occured.",
            message: "We could not save your \(action.title). Please retry or submit a bug report."
        )
    }
}

