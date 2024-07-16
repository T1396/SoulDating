//
//  BlockedUsersViewModel.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 16.07.24.
//

import Foundation

class BlockedUsersViewModel: BaseAlertViewModel {
    // MARK: properties
    private let firebaseManager = FirebaseManager.shared
    private let userService: UserService = .shared

    @Published var blockedUsers: [FireUser] = []
    @Published var isLoadingFinished = false

    private var userToUnblock: FireUser?

    // MARK: init
    override init() {
        super.init()
        fetchBlockedUsers()
    }


    // MARK: functions
    func attemptRemoveBlockedUser(user: FireUser) {
        print("attempted")
        let message = String(format: Strings.confirmationUnblock, user.name ?? "")
        userToUnblock = user
        createAlert(title: Strings.attention, message: message, onAccept: removeBlockedUser)
    }

    private func fetchBlockedUsers() {
        if let blockedUsers = userService.user.blockedUsers {
            fetchUsers(userIds: blockedUsers)
        } else {
            isLoadingFinished = true
        }
    }

    private func fetchUsers(userIds: [String]) {
        firebaseManager.database.collection("users")
            .whereField("id", in: userIds)
            .getDocuments { querySnapshot, error in
                if let error {
                    print("Failed to fetch blocked users", error.localizedDescription)
                    self.isLoadingFinished = true
                    return
                }

                self.blockedUsers = querySnapshot?.documents.compactMap { doc in
                    try? doc.data(as: FireUser.self)
                } ?? []
                self.isLoadingFinished = true
            }
    }

    private func removeBlockedUser() {
        guard let toRemoveUserId = userToUnblock?.id else { return }
        if let index = blockedUsers.firstIndex(where: { $0.id == toRemoveUserId }) {
            blockedUsers.remove(at: index)
        }

        if let index = userService.user.blockedUsers?.firstIndex(where: { $0 == toRemoveUserId }) {
            userService.user.blockedUsers?.remove(at: index)
        }
    }


}
