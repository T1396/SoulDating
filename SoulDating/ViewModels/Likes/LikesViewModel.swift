//
//  LikesViewModel.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 21.06.24.
//

import Foundation

let TAG = "(LikesViewModel)"

class LikesViewModel: ObservableObject {
    private let firebaseManager = FirebaseManager.shared
    private let rangeManager = RangeManager()
    
    @Published var usersWhoLikedCurrentUser: [FireUser] = mockUsers
    @Published var hasNoLikes = false
    var user: FireUser

    var currentUserId: String? {
        firebaseManager.userId
    }
    
    func distance(to targetLocation: LocationPreference) -> String? {
        rangeManager.distanceString(from: user.location, to: targetLocation)
    }
    
    init(user: FireUser) {
        self.user = user
        // fetchUsersWhoLiked()
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdate(_:)), name: .userDocumentUpdated, object: nil)
    }
    
    @objc
    private func didUpdate(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let updatedUser = userInfo["user"] as? FireUser else {
            print("Update user with notification failed")
            return
        }
        
        print("Updated with user notification successfully")
        self.user = updatedUser
    }
    
    
    private func fetchUsersWhoLiked() {
        guard let currentUserId else { return }
        firebaseManager.database.collection("userLikes")
            .document(currentUserId).collection("like").getDocuments { docSnapshot, error in
                if let error {
                    print("\(TAG) error while fetching userLikes", error.localizedDescription)
                    return
                }
                
                self.usersWhoLikedCurrentUser = docSnapshot?.documents.compactMap { doc in
                    do {
                        return try doc.data(as: FireUser.self)
                    } catch {
                        print("\(TAG) Error decoding firestore user data to userDetail struct", error.localizedDescription)
                        return nil
                    }
                } ?? []
                self.hasNoLikes = self.usersWhoLikedCurrentUser.isEmpty
            }
    }
}
