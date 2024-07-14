//
//  ConversationManager.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 13.07.24.
//

import Foundation

/// helper class to manage conversations
class ConversationManager: ObservableObject {
    @Published private (set) var conversations: [String: GptConversation] = [:]

    func addConversation() -> String {
        let newConversation = GptConversation(id: UUID().uuidString, messages: [], startDate: .now)
        DispatchQueue.main.async {
            self.conversations[newConversation.id] = newConversation
        }
        return newConversation.id
    }

    func getConversation(by id: String) -> GptConversation? {
        conversations[id]
    }

    func appendFetchedConversations(_ convos: [GptConversation]) {
        for convo in convos {
            conversations[convo.id] = convo
        }
    }

    func appendMessageToConversation(_ message: GptMessage, to conversationId: String) {
        conversations[conversationId]?.messages.append(message)
    }
}
