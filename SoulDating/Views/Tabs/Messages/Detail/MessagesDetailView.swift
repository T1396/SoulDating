//
//  ChatMessagesView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 19.06.24.
//

import SwiftUI

struct MessagesDetailView: View {
    // MARK: properties
    let userId: String
    let chatId: String

    @EnvironmentObject var chatViewModel: MessagesViewModel

    @State private var isLoadingUser = true
    @State private var user: FireUser?

    // MARK: body
    var body: some View {
        VStack {
            if isLoadingUser {
                ProgressView()
                    .scaleEffect(1.5)
            } else {
                if chatViewModel.fetchErrorOccured {
                    Text(Strings.fetchUserError)
                } else {
                    if let user {
                        MessageAndProfileView(contentType: .message, targetUser: user, chatId: chatId, image: .constant(nil))
                    }
                }
            }

        }
        .onAppear {
            chatViewModel.fetchAndReturnUser(userId: userId) { user in
                self.user = user
                isLoadingUser = false
            }
        }
    }
}

#Preview {
    MessagesDetailView(userId: "kdlsa", chatId: "dskal")
}
