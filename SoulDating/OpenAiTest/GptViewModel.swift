//
//  BotViewModel.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 26.06.24.
//

import SwiftUI
import Foundation
import SwiftOpenAI


struct BotAnswer: Identifiable, Hashable {
    let id: String
    let message: String
}

class GptViewModel: ObservableObject {
    
    private let service: OpenAIService
    
    // the pick up line options
    @Published var lineOptions: [BotAnswer] = []
    @Published var isWaitingForBotAnswer = false
    @Published var errorMessage: String?
    
    init() {
        let apiKey = "sk-proj-hHYZSumagF1RmnIiN5kgT3BlbkFJk64kg1PrNAVqjOLo9RSj"
        service = OpenAIServiceFactory.service(apiKey: apiKey)
    }
    

    
    func generatePickupLines(user: User, completion: @escaping () -> Void) async {
        isWaitingForBotAnswer = true
        let prompt = buildQueryForUser(user: user)
        let parameters = ChatCompletionParameters(messages: [
            .init(role: .user, content: .text(prompt))
        ], model: .gpt35Turbo)
        
        do {
            // wait for answer
            let choices = try await service.startChat(parameters: parameters)
            let answers = choices.choices.map { ($0.message.content ?? "Error message", UUID().uuidString) }
            let first = answers.first?.0 ?? "No message jooooo"
            print(answers)
            
            let botAnswers = try parseBotAnswers(from: first)
            DispatchQueue.main.async {
                self.lineOptions = botAnswers
                completion()
            }
        } catch let error as NSError {
            print("Error getting chat choices \(error.localizedDescription), details: \(error.userInfo)")
            errorMessage = "There was an technical issue. Please try it again or if that doesnt help contact us."
            completion()
        }
        DispatchQueue.main.async {
            self.isWaitingForBotAnswer = false
        }
    }
    
    
    /// parses a bot answer which has different answers in a single string into an array with the seperated answers
    ///  e.g. "1. XYZ"  "2. ABC" " 3. DEF" gets parsed into an array containing each number and string
    private func parseBotAnswers(from text: String) throws -> [BotAnswer] {
        let pattern = #"(\d+)\.\s*"(.*?)""#
        let regex = try NSRegularExpression(pattern: pattern)
        let range = NSRange(text.startIndex..., in: text)
        let matches = regex.matches(in: text, range: range)
        
        return matches.compactMap { match in
            if match.numberOfRanges == 3,
               let numberRange = Range(match.range(at: 1), in: text),
               let itemRange = Range(match.range(at: 2), in: text) {
                
                let content = String(text[itemRange])
                let number = String(text[numberRange])
                return BotAnswer(id: number, message: content)
            }
            return nil
        }
    }
    
    
    func buildQueryForUser(user: User) -> String {
        // create a prompt to generate 5 pickup lines with user details
        let start = """
Please generate exactly five pickup lines, numbered 1 through 5. Each pickup line should be enclosed in quotation marks, without any extra quotation marks around the entire response or additional text. Ensure the format is adhered to strictly with each line on a new line, like this:

1. "Example of a pickup line"
2. "Example of a pickup line"
3. "Example of a pickup line"
4. "Example of a pickup line"
5. "Example of a pickup line"

Please output the pickup lines individually, following the numbering precisely, and make sure no additional formatting or characters are included outside of the required quotation marks and text.

Also try to match the pickup line if possible with the following user details:
"""
        let interests = user.general.interests?.map { $0.title}.seperated(emptyText: "No Interests provided") ?? "No Interests provided"
        let userInfo = "Userdetails: \(user.nameAgeString) years old, from \(user.location.name). Gender: \(user.gender?.title ?? "Unknown"), Interests: \(interests)"
        let finalPrompt = start + userInfo
        return finalPrompt
    }
    
}
