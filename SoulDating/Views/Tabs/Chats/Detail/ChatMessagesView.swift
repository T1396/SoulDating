//
//  ChatMessagesView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 19.06.24.
//

import SwiftUI

struct ChatMessagesView: View {
    // MARK: properties
    let userId: String
    let chatId: String
    
    @EnvironmentObject var chatViewModel: ChatViewModel

    @State private var isLoadingUser = true
    @State private var user: User?
    
    // MARK: body
    var body: some View {
        VStack {
            if isLoadingUser {
                ProgressView()
                    .scaleEffect(1.5)
            } else {
                if let user {
                    WriteMessageView(targetUser: user, chatId: chatId)
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
    ChatMessagesView(userId: "kdlsa", chatId: "dskal")
}
