//
//  SwipeUserViewModel.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 21.06.24.
//

import Foundation
import Firebase
import SwiftUI

protocol SwipeUserDelegate: AnyObject {
    func userDidSwipe(_ userId: String, action: SwipeAction)
    func userDidReport(_ userId: String)
}

class SwipeUserViewModel: BaseAlertViewModel, Identifiable {
    // MARK: properties
    weak var delegate: SwipeUserDelegate?
    
    private let TAG = "(SwipeUserViewModel)"
    private let firebaseManager = FirebaseManager.shared
    private let rangeManager = RangeManager()
    private let userService: UserService
    @Published var otherUser: FireUser

    // MARK: init
    init(otherUser: FireUser, userService: UserService = .shared) {
        self.otherUser = otherUser
        self.userService = userService
    }
    
    // MARK: computed properties
    var isNewUser: Bool {
        if let date = otherUser.registrationDate, !date.isOlderThan30Days {
            return true
        } else {
            return false
        }
    }
    
    
    
    // MARK: functions
    private func removeUserAfterSwipe(_ action: SwipeAction) {
        // send notification with delegate to remove swiped user from the list in swipeListViewModel
        DispatchQueue.main.async {
            self.delegate?.userDidSwipe(self.otherUser.id, action: action)
        }
    }

    func removeUserAfterBlock() {
        DispatchQueue.main.async {
            self.delegate?.userDidReport(self.otherUser.id)
        }
    }

    
}

extension SwipeUserViewModel {
    var distance: String? {
        rangeManager.distanceString(from: userService.user.location, to: otherUser.location)
    }
    
    /// Sets a like dislike  or superlike after a swipe and updates it to firestore,
    /// sets one document for the current user where all likes of himself are saved
    /// sets another document for the targetUser so all likes can be accessed easier in e.g. LikesView
    func setActionAfterSwipe(_ action: SwipeAction) {
        guard let userId = firebaseManager.userId else { return }
        
        let db = firebaseManager.database
        let batch = db.batch()
        
        // currentUser swipe metadata
        let swipe = Swipe(fromUserId: userService.user.id, targetUserId: otherUser.id, action: action, timestamp: .now)
        // the liked/dislikes user swipe metadata
        let targetUserSwipe = UserSwipe(action: action, fromUserId: userService.user.id, timestamp: .now)
        
        let userActionRef = db.collection("userActions").document(userId).collection("actions").document()
        if action == .like {
            let targetUserLikesRef = db.collection("userLikes").document(otherUser.id)
                .collection(action.rawValue).document()
            do {
                try batch.setData(from: targetUserSwipe, forDocument: targetUserLikesRef)
            } catch {
                print("error setting targetUserLike", error.localizedDescription)
            }
        }

        do {
            try batch.setData(from: swipe, forDocument: userActionRef)
        } catch {
            print("\(self.TAG) Error encoding swipe / user swipe struct", error.localizedDescription)
        }
        
        batch.commit { error in
            if let error {
                print("Error saving user interaction \(action.rawValue)", error.localizedDescription)
                return
            }
            // if successfully committed, remove user with delegate from list of swipeable users
            print("successfully set \(action.title)")
            self.removeUserAfterSwipe(action)
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
