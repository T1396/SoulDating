//
//  OpenAIView2.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 26.06.24.
//

import SwiftUI

struct OpenAIView2: View {
    @State private var input = ""
    @StateObject private var viewModel = ChatMessageViewModel(idProvider: { UUID().uuidString })
    var body: some View {
        VStack {
            ScrollView {
                
                ForEach(viewModel.messages) { message in
                    MessageView2(role: message.isUser, message: message.message)
                        .padding(5)
                }

            }
            Divider()
            HStack {
                TextField("Message....", text: $input)
                    .padding(5)
                    .background(.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                Button {
                    print("Button pressed JO")
                    viewModel.sendChatMessage(prompt: input) { message in
                    
                    }
//                    if let selectedConversationID = chatStore.selectedConversationID {
//                        let newMessage = OpenAIMessage(id: UUID().uuidString, role: .user, content: input, createdAt: Date())
//                        print(newMessage)
//                        Task {
//                            await chatStore.sendMessage(newMessage, conversationId: selectedConversationID, model: .gpt3_5Turbo)
//                        }
//                    }
                    input = ""
                    
                } label: {
                    Image(systemName: "paperplane")
                }
            }
            .padding()
//            .onAppear {
//                if chatStore.conversations.isEmpty {
//                    chatStore.createConversation()
//                }
//                if chatStore.selectedConversationID == nil {
//                    chatStore.selectConversation(chatStore.conversations.first?.id)
//                }
//            }
        }
    }
}

struct MessageView2: View {
    enum Role { case user, target }
    var role: Bool
    var message: String
    
    
    var body: some View {
        Group {
            HStack {
                if role {
                    Spacer()
                    Text(message)
                        .padding()
                        .background(.blue)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                } else {
                    Text(message)
                        .padding()
                        .background(.green)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    OpenAIView2()
}
