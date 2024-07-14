//
//  MessagesView.swift
//
//
//  Created by Philipp Tiropoulos on 10.06.24.
//

import SwiftUI

struct MessagesView: View {
    @StateObject private var messagesVm: MessagesViewModel = .init()
    @State private var chatId: String = ""
    @Binding var activeTabViewTab: Tab

    init(activeTabViewTab: Binding<Tab>) {
        self._activeTabViewTab = activeTabViewTab
        print("messagesView initialized")
    }

    var body: some View {
        VStack {
            if messagesVm.finishedLoading {
                if !messagesVm.chatDetails.isEmpty {
                    ScrollView {
                        ForEach(messagesVm.chatDetails, id: \.chat.id) { chat, userDetail in

                            MessagesChatRow(userDetail: userDetail, chat: chat, chatVm: messagesVm)
                        }
                    }
                    .scrollIndicators(.hidden)

                } else {
                    VStack {
                        Text(Strings.noMessages)
                            .multilineTextAlignment(.center)
                            .appFont(size: 24, textWeight: .bold)
                        Button {
                            activeTabViewTab = .swipe
                        } label: {
                            Text(Strings.goToSwipe)
                                .appButtonStyle()
                        }
                    }
                    .padding()
                }
            } else {
                ProgressView(Strings.loadingChats)
            }

        }
        .onAppear(perform: messagesVm.subscribe)
        .onDisappear(perform: messagesVm.unsubscribe)
        .navigationTitle(Tab.messages.title)
    }
}

struct MessagesChatRow: View {
    // MARK: properties
    var userDetail: UserDetail
    var chat: Chat
    @ObservedObject var chatVm: MessagesViewModel

    @State private var navigateToUser = false

    // MARK: body
    var body: some View {
        Button {
            navigateToUser = true
        } label: {
            HStack(spacing: 8) {
                RoundWebImage(imageUrl: userDetail.profileImageUrl, width: 60, height: 60)

                VStack(alignment: .leading) {
                    Text(userDetail.name)
                        .appFont(size: 16, textWeight: .bold)
                    Text(chat.lastMessageContent)
                        .lineLimit(1)
                        .appFont(size: 14)
                }

                Spacer()

                if let unreadCount = chatVm.unreadMessagesForChats[chat.id ?? ""], unreadCount > 0 {
                    Text(String(chatVm.unreadMessagesForChats[chat.id ?? ""] ?? 0))
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
        }
        .fullScreenCover(isPresented: $navigateToUser, content: {
            if let chatId = chat.id {
                MessagesDetailView(userId: userDetail.id, chatId: chatId)
                    .environmentObject(chatVm)
            }
        })
        .padding(.horizontal)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    MessagesView(activeTabViewTab: .constant(.messages))
}
