//
//  ChatMessageViewModel.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 05.06.24.
//

import Foundation
import OpenAI

struct ChatMessage: Identifiable {
    var id = UUID()
    var message: String
    var isUser: Bool
}

final class ChatMessageViewModel: ObservableObject {
    @Published var messages: [ChatMessage]
    
    @Published var conversations: [Conversation] = []
    @Published var conversationErrors: [Conversation.ID: Error] = [:]
    @Published var selectedConversationID: Conversation.ID?
    
    @Published var responses: [String] = []
    
    private var openAI: OpenAIProtocol
    let idProvider: () -> String
    
    init(
        idProvider: @escaping () -> String
    ) {
        self.openAI = OpenAI(apiToken: "sk-proj-hHYZSumagF1RmnIiN5kgT3BlbkFJk64kg1PrNAVqjOLo9RSj")
        self.idProvider = idProvider
        self.messages = []
    }


    
//    func sendUserMessage(_ message: String) {
//        let userMessage = ChatMessage(message: message, isUser: true)
//        messages.append(userMessage)
//        
//        openAI?.sendCompletion(with: message, maxTokens: 50, completionHandler: { [weak self] result in
//            switch result {
//            case .success(let model):
//                print("completed")
//                if let response = model.choices?.first?.text {
//                    print("RESPONSE: \(response)")
//                    self?.receiveBotMessage(response)
//                }
//            case .failure(let error):
//                // handle errors later
//                print("Error sending api message to chatbot", error.localizedDescription)
//                break
//            }
//        })
//    }
    
    private func receiveBotMessage(_ message: String) {
        let botMessage = ChatMessage(message: message, isUser: false)
        messages.append(botMessage)
    }
}
extension ChatMessageViewModel {
 
    func send(text: String, user: User) async -> String? {
        let startPrompt = "Generate a short pickup line for me. I want you to not write anything else just the one pickup line. It should match a bit with the following user details and should be creative"
        let interests = user.general.interests?.map { $0.title}.seperated(emptyText: "No Interests provided") ?? "No Interests provided"
        let prompt = "Userdetails: \(user.nameAgeString) years old, from \(user.location.name). Gender: \(user.gender?.title ?? "Unknown"), Interests: \(interests)"
        let finalPrompt = startPrompt + prompt
        
        if let message: ChatQuery.ChatCompletionMessageParam = .init(role: .user, content: finalPrompt) {
            print("Created message param")
            let chatQuery = ChatQuery(messages: [message], model: .gpt3_5Turbo, maxTokens: 15, temperature: 0.8)
            do {
                let result = try await openAI.chats(query: chatQuery)
                self.responses = result.choices.map { $0.message.content?.string ?? "Error Response" } 
                return result.choices.first?.message.content?.string
            } catch {
                print("Error getting chatquery result", error.localizedDescription)
                return nil
            }
        } else {
            print("NOT CREATED message param")
            return nil
        }
//        let chatQuery = ChatQuery(messages: [.init(role: .user, content: "hallo")], model: )
//        let cd = CompletionsQuery(model: .gpt3_5Turbo, prompt: finalPrompt, temperature: 0.9, maxTokens: 80)
//        do {
//            let result = try await openAI.chats(query: cd)
//            let bla = result.choices.first(where: { $0.finishReason == "stop" })
//            return bla
//        } catch {
//            print("Error getting openAI result completion", error.localizedDescription)
//            return nil
//        }
        
    }
}

extension ChatMessageViewModel {
    func sendChatMessage(prompt: String, completion: @escaping (String) -> Void) {
        if let message: ChatQuery.ChatCompletionMessageParam = .init(role: .user, content: prompt) {
            let ownMessage = ChatMessage(message: prompt, isUser: true)
            self.messages.append(ownMessage)
            let chatQuery = ChatQuery(messages: [message], model: .gpt3_5Turbo)
            openAI.chats(query: chatQuery) { result in
                switch result {
                case .success(let success):
                    let message = ChatMessage(message: success.choices.first?.message.content?.string ?? "Error", isUser: false)
                    self.messages.append(message)
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            }
        }
        
    }
}

extension ChatMessageViewModel {
    func sendMsg(
        _ message: OpenAIMessage,
        conversationId: Conversation.ID,
        model: Model = .gpt3_5Turbo
    ) async {
        guard let conversationIndex = conversations.firstIndex(where: { $0.id == conversationId }) else {
            return
        }
        
        conversations[conversationIndex].messages.append(message)
        
        
    }
    
    @MainActor
    func completeChat(
        conversationId: Conversation.ID,
        model: Model = .gpt3_5Turbo
    ) {
        guard let conversation = conversations.firstIndex(where: { $0.id == conversationId }) else {
            return
        }
        
        conversationErrors[conversationId] = nil
        
        do {
            guard let conversationIndex = conversations.firstIndex(where: { $0.id == conversationId}) else {
                return
            }
            
            let pickUpFunction = ChatQuery.ChatCompletionToolParam(function:
                    .init(
                        name: "pickup",
                        description: "Let ChatGPT create your pickup lines.",
                        parameters: .init(
                            type: .object
                        )
                    )
            )
            
        } catch {
            
        }
    }
    
//    func createPersonalizedQuery(for user: User) -> ChatQuery {
//     
//        let function = [
//            ChatQuery.ChatCompletionToolParam(function:
//                    .init(
//                        name: "pickUp",
//                        description: "Let a bot create pickuplines for you",
//                        parameters: .init(
//                            type: .object,
//                            properties: [
//                                "location": .init(type: .string, description: user.location.name),
//                                "interests": .init(type: .string, description: "")
//                            ]
//                        )
//                    )
//                                             
//                                             )
//        ]
//    }
}
