//
//  LikesService.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 15.07.24.
//

import Foundation

/// manages all outgoing or incoming likes and superlikes as well as disliked users to prevent liking again in otherProfileView, implemented as singleton
class LikesService: ObservableObject {
    // MARK: properties
    static let shared = LikesService()
    private let firebaseManager = FirebaseManager.shared

    @Published private (set) var userIdsWhoLikedCurrent: Set<String> = []
    @Published private (set) var userIdsCurrentUserLiked: Set<String> = []
    @Published private (set) var superLikedUserIds: Set<String> = []
    @Published private (set) var dislikedUserIds: Set<String> = []

    private init() {
        guard let userId = firebaseManager.userId else { return }
        listenForLikes(for: userId)
        listenForDislikedUserIds(for: userId)
        listenForUserIdsCurrentUserLiked(userId: userId)
        listenForIdsCurrentUserSuperLiked(userId: userId)
    }

    // MARK: computed properties
    private var likedOrDislikedIds: Set<String> {
        userIdsCurrentUserLiked.union(superLikedUserIds).union(dislikedUserIds)
    }

    func userAlreadyInteractedWithUser(with userId: String) -> Bool {
        guard let currentUserId = firebaseManager.userId else { return false }
        return likedOrDislikedIds.contains(userId)
    }

    private func listenForLikes(for userId: String) {
        firebaseManager.database.collection("userLikes").document(userId)
            .collection("like")
            .addSnapshotListener { querySnapshot, error in
                if let error {
                    print("error in snapshotlistener for likes for current user", error.localizedDescription)
                    return
                }
                let userIds = querySnapshot?.documents.compactMap { doc in
                    doc.data()["fromUserId"] as? String
                } ?? []
                self.userIdsWhoLikedCurrent.formUnion(userIds)
                print("selfUserIdsWholikedcurrent = \(self.userIdsWhoLikedCurrent)")
            }
    }

    private func listenForDislikedUserIds(for userId: String) {
        firebaseManager.database.collection("userActions").document(userId)
            .collection("actions")
            .whereField("action", isEqualTo: SwipeAction.dislike.rawValue)
            .addSnapshotListener { docSnapshot, error in
                if let error {
                    print("Error fetching the users the current user likes", error.localizedDescription)
                    return
                }
                let dislikedUserIds = docSnapshot?.documents.compactMap { doc in
                    doc.data()["targetUserId"] as? String
                } ?? []
                self.dislikedUserIds.formUnion(dislikedUserIds)
                // filter the ids of the users to only fetch users that werent fetched already
            }
    }

    private func listenForUserIdsCurrentUserLiked(userId: String) {
        firebaseManager.database.collection("userActions").document(userId)
            .collection("actions")
            .whereField("action", isEqualTo: SwipeAction.like.rawValue)
            .addSnapshotListener { docSnapshot, error in
                if let error {
                    print("Error fetching the users the current user likes", error.localizedDescription)
                    return
                }
                let usersWhoLikedIds = docSnapshot?.documents.compactMap { doc in
                    doc.data()["targetUserId"] as? String
                } ?? []
                self.userIdsCurrentUserLiked.formUnion(usersWhoLikedIds)
                // filter the ids of the users to only fetch users that werent fetched already
            }
    }

    private func listenForIdsCurrentUserSuperLiked(userId: String) {
        firebaseManager.database.collection("userActions").document(userId)
            .collection("actions")
            .whereField("action", isEqualTo: SwipeAction.superlike.rawValue)
            .addSnapshotListener { docSnapshot, error in
                if let error {
                    print("Error fetching the users the current user likes", error.localizedDescription)
                    return
                }
                let superLikedUserIds = docSnapshot?.documents.compactMap { doc in
                    doc.data()["targetUserId"] as? String
                } ?? []
                self.superLikedUserIds.formUnion(superLikedUserIds)
                // filter the ids of the users to only fetch users that werent fetched already
            }
    }
}
