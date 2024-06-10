//
//  NewContent.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 05.06.24.
//

import SwiftUI
import OpenAI

struct OpenAITestView: View {
    @StateObject private var chatStore = ChatStore(openAIClient: OpenAI(apiToken: "sk-proj-F7AAaOMdznxwL2ziwQFfT3BlbkFJZHRb5hJOLyhgrIj9ZfTX"), idProvider: { UUID().uuidString })
    @State private var input = ""
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(chatStore.conversations.flatMap { $0.messages }) { message in
                    MessageView(message: message)
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
                    if let selectedConversationID = chatStore.selectedConversationID {
                        let newMessage = Message(id: UUID().uuidString, role: .user, content: input, createdAt: Date())
                        print(newMessage)
                        Task {
                            await chatStore.sendMessage(newMessage, conversationId: selectedConversationID, model: .gpt3_5Turbo)
                        }
                    }
                    input = ""
                    
                } label: {
                    Image(systemName: "paperplane")
                }
            }
            .padding()
            .onAppear {
                if chatStore.conversations.isEmpty {
                    chatStore.createConversation()
                }
                if chatStore.selectedConversationID == nil {
                    chatStore.selectConversation(chatStore.conversations.first?.id)
                }
            }
        }
    }
}

struct MessageView: View {
    var message: Message
    
    var body: some View {
        Group {
            HStack {
                if message.role == .user {
                    Spacer()
                    Text(message.content)
                        .padding()
                        .background(.blue)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                } else {
                    Text(message.content)
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
    OpenAITestView()
}
