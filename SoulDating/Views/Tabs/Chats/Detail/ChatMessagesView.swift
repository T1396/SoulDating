//
//  ChatMessagesView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 19.06.24.
//

import SwiftUI

struct ChatMessagesView: View {
    @EnvironmentObject var chatViewModel: ChatViewModel
    let userId: String
    let chatId: String
    @State private var isLoadingUser = true
    @State private var user: User?
    var body: some View {
        VStack {
            if isLoadingUser {
                ProgressView()
                    .scaleEffect(1.5)
            } else {
                if let user {
                    WriteMessageView(targetUser: user, chatId: chatId, isPresented: .constant(true))
                }
            }
        }
        .onAppear {
            chatViewModel.fetchAndReturnUser(userId: userId) { user in
                isLoadingUser = false
                self.user = user
            }
        }
    }
}

#Preview {
    ChatMessagesView(userId: "kdlsa", chatId: "dskal")
}
