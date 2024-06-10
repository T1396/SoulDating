//
//  ApiCaller.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 05.06.24.
//

import Foundation
import OpenAI

struct Message: Identifiable {
    var id: UUID = .init()
    var content: String
    var isUser: Bool
}

class ChatController: ObservableObject {
    @Published var messsages: [Message] = [.init(content: "Hello", isUser: true), .init(content: "Jello", isUser: false)]
    
    let openAI = OpenAI(apiToken: "sk-proj-wDe6MmUDUBg3vF5fgIHyT3BlbkFJx7580aSYt3FyxGya9i7u")
    
    func sendNewMessage(content: String) {
        let userMessage = Message(content: content, isUser: true)
        self.messsages.append(userMessage)
        getBotReply()
    }
    
    func getBotReply() {
        openAI.chats(query: .init(messages: <#T##[ChatQuery.ChatCompletionMessageParam]#>, model: <#T##Model#>), completion: <#T##(Result<ChatResult, any Error>) -> Void#>)
    }
}

//final class ApiCaller {
//    static let shared = ApiCaller()
//    
//    @frozen enum Constants {
//        static let key = "sk-proj-wDe6MmUDUBg3vF5fgIHyT3BlbkFJx7580aSYt3FyxGya9i7u"
//    }
//    
//    private var client: OpenAI?
//    
//    private init() {}
//    
//    func setup() {
//        let client = OpenAI(apiToken: Constants.key)
//        self.client = client
//    }
//    
//    func getResponse(input: String, completion: @escaping (Result<String, Error>) -> Void) {
//            guard let client = client else {
//                completion(.failure(NSError(domain: "ApiCaller", code: -1, userInfo: [NSLocalizedDescriptionKey: "Client not initialized"])))
//                return
//            }
//                    
//        let query = ChatQuery(messages: [.init(role: .user, content: "who are youuu")!], model: .gpt3_5Turbo)
//            
//            client.chats(query: query) { result in
//                switch result {
//                case .success(let chatResult):
//                    if let message = chatResult.choices.first?.message.content {
//                        completion(.success(message))
//                    } else {
//                        completion(.failure(NSError(domain: "ApiCaller", code: -1, userInfo: [NSLocalizedDescriptionKey: "No response from API"])))
//                    }
//                case .failure(let error):
//                    completion(.failure(error))
//                }
//            }
//        }
//}
