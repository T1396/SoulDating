//
//  MessagesView.swift
//
//
//  Created by Philipp Tiropoulos on 10.06.24.
//

import SwiftUI

struct ChatsView: View {
    @EnvironmentObject var chatViewModel: ChatViewModel
    
    var body: some View {
            ScrollView {
                ForEach(Array(chatViewModel.chatUserDetails), id: \.key.id) { chat, userDetail in
                    NavigationLink {
                        if let chatId = chat.id {
                            ChatMessagesView(userId: userDetail.id, chatId: chatId)
                                .navigationBarBackButtonHidden(true)
                                .environmentObject(chatViewModel)
                        }
                    } label: {
                        HStack(spacing: 8) {
                            RoundAsyncImage(imageUrl: userDetail.profileImageUrl, width: 60, height: 60)
                            
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(userDetail.name)
                                        .appFont(size: 16, textWeight: .bold)
                                    Spacer()
                                    Text(chat.lastMessageTimestamp.toTimeString())
                                        .font(.caption.weight(.thin))
                                        .multilineTextAlignment(.trailing)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                }
                                Text(chat.lastMessageContent)
                                    .appFont(size: 14)
                            }
                            .padding(.vertical)
                            .foregroundStyle(.foreground)
                        }
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
    ChatsView()
        .environmentObject(ChatViewModel())
}
