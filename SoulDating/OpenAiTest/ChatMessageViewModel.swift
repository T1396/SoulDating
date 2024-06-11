//
//  ChatMessageViewModel.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 05.06.24.
//

import Foundation
import OpenAISwift

struct ChatMessage: Identifiable {
    var id = UUID()
    var message: String
    var isUser: Bool
}

final class ChatMessageViewModel: ObservableObject {
    @Published var messages: [ChatMessage]
    
    private var openAI: OpenAISwift?
    
    init() {
        let config: OpenAISwift.Config = .makeDefaultOpenAI(apiKey: "sk-proj-wDe6MmUDUBg3vF5fgIHyT3BlbkFJx7580aSYt3FyxGya9i7u")
        openAI = OpenAISwift(config: config)
        messages = []
    }

    
    func sendUserMessage(_ message: String) {
        let userMessage = ChatMessage(message: message, isUser: true)
        messages.append(userMessage)
        
        openAI?.sendCompletion(with: message, maxTokens: 50, completionHandler: { [weak self] result in
            switch result {
            case .success(let model):
                print("completed")
                if let response = model.choices?.first?.text {
                    self?.receiveBotMessage(response)
                }
            case .failure(let error):
                // handle errors later
                print("Error sending api message to chatbot", error.localizedDescription)
                break
            }
        })
    }
    
    private func receiveBotMessage(_ message: String) {
        let botMessage = ChatMessage(message: message, isUser: false)
        messages.append(botMessage)
    }
}
