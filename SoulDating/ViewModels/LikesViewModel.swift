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
    
    @Published var usersWhoLikedCurrentUser: [UserDetail] = []
    private var user: User
    
    var currentUserId: String? {
        firebaseManager.userId
    }
    
    init(user: User) {
        self.user = user
        fetchUsersWhoLiked()
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
                        return try doc.data(as: UserDetail.self)
                    } catch {
                        print("\(TAG) Error decoding firestore user data to userDetail struct", error.localizedDescription)
                        return nil
                    }
                } ?? []
            }
    }
}
