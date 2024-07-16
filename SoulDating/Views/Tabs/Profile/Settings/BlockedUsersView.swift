//
//  BlockedUsersView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 16.07.24.
//

import SwiftUI

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

struct BlockedUsersView: View {
    // MARK: properties
    @StateObject private var blockedVm: BlockedUsersViewModel = .init()

    private let gridItems = [ GridItem(.flexible()), GridItem(.flexible()) ]

    var body: some View {
        NavigationStack {
            Group {
                if blockedVm.blockedUsers.isEmpty && blockedVm.isLoadingFinished {
                    Text("You dont have any blocked users yet")
                        .appFont(size: 22, textWeight: .bold)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                } else {

                    Text("Your currently blocked users")
                        .appFont(size: 20, textWeight: .bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)

                    GeometryReader { geometry in
                        let width = (geometry.size.width - 40) / 2
                        let height = width * 4 / 3


                        ScrollView {
                            //Spacer(minLength: 32)
                            LazyVGrid(columns: gridItems, content: {
                                ForEach(blockedVm.blockedUsers) { user in
                                    ZStack {
                                        ImageWithGradientAndName(user: user, distance: nil, minWidth: width, minHeight: height)


                                        Button {
                                            blockedVm.attemptRemoveBlockedUser(user: user)
                                        } label: {
                                            Image(systemName: "trash.fill")
                                                .padding()
                                                .foregroundStyle(.red)
                                                .background()
                                                .clipShape(Circle())
                                        }
                                        .padding([.trailing, .top], 8)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                                    }
                                }
                            }).padding(.horizontal)
                        }
                    }
                }
            }
        }

        .alert(blockedVm.alertTitle, isPresented: $blockedVm.showAlert) {
            if let action = blockedVm.onAcceptAction {
                Button(Strings.cancel, role: .cancel, action: blockedVm.dismissAlert)
                Button("OK", role: .destructive, action: action)
            } else {
                Button(Strings.cancel, action: blockedVm.dismissAlert)
            }
        } message: {
            Text(blockedVm.alertMessage)
        }
    }
}

#Preview {
    BlockedUsersView()
}
