//
//  MessagesView.swift
//
//
//  Created by Philipp Tiropoulos on 10.06.24.
//

import SwiftUI

struct MessagesView: View {
    @EnvironmentObject var chatViewModel: ChatViewModel
    
    var body: some View {
            ScrollView {
                ForEach(chatViewModel.chatDetails, id: \.chat.id) { chat, userDetail in
                    NavigationLink {
                        if let chatId = chat.id {
                            MessagesDetailView(userId: userDetail.id, chatId: chatId)
                                .toolbarRole(.editor)
                                .environmentObject(chatViewModel)
                        }
                    } label: {
                        HStack(spacing: 8) {
                            RoundAsyncImage(imageUrl: userDetail.profileImageUrl, width: 60, height: 60)
                            
                            VStack(alignment: .leading) {
                                Text(userDetail.name)
                                    .appFont(size: 16, textWeight: .bold)
                                Text(chat.lastMessageContent)
                                    .lineLimit(1)
                                    .appFont(size: 14)
                            }

                            Spacer()

                            if let unreadCount = chatViewModel.unreadMessagesForChats[chat.id ?? ""], unreadCount > 0 {
                                Text(String(chatViewModel.unreadMessagesForChats[chat.id ?? ""] ?? 0))
                                    .appFont(size: 14)
                                    .padding(5)
                                    .foregroundStyle(.white)
                                    .background(
                                        Circle()
                                            .fill(.red)
                                    )
                            }
                            Text(chat.lastMessageTimestamp.toTimeString())
                                .font(.caption.weight(.thin))
                        }
                        .foregroundStyle(.foreground)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity)
                    }
                    
                }
            }
            .scrollIndicators(.hidden)
            .navigationTitle(Tab.messages.title)

        
    }
}

#Preview {
    MessagesView()
        .environmentObject(ChatViewModel())
}
