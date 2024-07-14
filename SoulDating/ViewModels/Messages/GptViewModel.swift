//
//  BotViewModel.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 26.06.24.
//

import SwiftUI
import Foundation
import SwiftOpenAI

class GptViewModel: BaseAlertViewModel {
    // MARK: properties
    private let service: OpenAIService
    private let firebaseManager = FirebaseManager.shared

    private var conversations: [GptConversation] = []
    private var lastGptAnswer: GptMessage? // holds the whole last answer to save it to firestore etc
    // chunks of answers will be appended to this variable and
    private var botMessage = "" {
        didSet {
            DispatchQueue.main.async {
                self.displayBotMessage = self.botMessage
            }
        }
    }
    // published var to show the conversation answers while they are beeing build, will be reset if the message finished to update UI
    @Published var displayBotMessage = ""
    // the current user message
    @Published var gptChatInput = ""
    // the pick up line options
    @Published var lineOptions: [GptAnswer] = []
    @Published var isWaitingForBotAnswer = false
    @Published var errorMessage: String?
    
    @Published private (set) var selectedConversationID: String?
    @Published private (set) var conversationManager = ConversationManager()

    // MARK: init
    override init() {
        let apiKey = "sk-proj-hHYZSumagF1RmnIiN5kgT3BlbkFJk64kg1PrNAVqjOLo9RSj"
        service = OpenAIServiceFactory.service(apiKey: apiKey)
        super.init()
        guard let userId = firebaseManager.userId else { return }
        self.loadConversations(userId: userId)
    }
    
    // MARK: computed properties
    var selectedConversation: GptConversation? {
        if let selectedConversationID {
            return conversationManager.getConversation(by: selectedConversationID)
        }
        return nil
    }
    
    // sorted conversations
    var gptConversations: [GptConversation] {
        conversationManager.conversations.map { $0.value }.sorted(by: { $0.startDate > $1.startDate })
    }
    
    var sendMessageDisabled: Bool {
        gptChatInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }


    // MARK: functions
    func conversationToDict(_ conversation: GptConversation) -> [String: Any] {
        let data: [String: Any] = [
            "id": conversation.id,
            "startDate": conversation.startDate,
            "messages": conversation.messages.map { message in
                [
                    "id": message.id,
                    "text": message.text,
                    "isFromUser": message.isFromUser,
                    "timestamp": message.timestamp
                ]
            }
        ]
        return data
    }
}

// MARK: conversations
extension GptViewModel {
    @MainActor
    func sendConversationMessage() async {
        guard let userId = firebaseManager.userId else { return }
        let messageContent = gptChatInput
        gptChatInput = ""
        let message = GptMessage(id: UUID().uuidString, text: messageContent, isFromUser: true, timestamp: .now)
        
        if let selectedConversationID, let conversation = conversationManager.getConversation(by: selectedConversationID) {
            conversationManager.appendMessageToConversation(message, to: selectedConversationID)
            await continueConversation(conversation: conversation, userId: userId, prompt: messageContent)
        } else {
            createAlert(title: "Error", message: "Something went wrong, your message could not be send...")
        }
    }
    
    /// takes a conversation as parameter to continue the conversation, inserting all previous messages into the completionParam
    private func continueConversation(conversation: GptConversation, userId: String, prompt: String) async {
        // create messages list of all previous conversation messages to serve as input param
        var messages = conversation.messages.map { ChatCompletionParameters.Message(role: .user, content: .text($0.text)) }
        messages.append(.init(role: .user, content: .text(prompt)))

        // create completion params
        let parameters = ChatCompletionParameters(messages: messages, model: .gpt35Turbo)

        do {
            let chatCompletionObject = try await service.startStreamedChat(parameters: parameters)

            // chat completion returns the answer in chunks
            for try await chunk in chatCompletionObject {
                handleConversationChunks(from: chunk)
            }
            // append answer if successfully received and save into firestore
            if let lastGptAnswer {
                conversationManager.appendMessageToConversation(lastGptAnswer, to: conversation.id)
                saveConversationToFirestore(id: conversation.id, for: userId)
            }
        } catch {
            print("Error continuing the conversation", error.localizedDescription)
        }
    }

    ///  takes the chatCompletionChunkObject and creates a messages from the chunks to save it to "lastGptAnswer"
    private func handleConversationChunks(from chatCompletionChunk: ChatCompletionChunkObject) {
        for choice in chatCompletionChunk.choices {
            if let delta = choice.delta.content {
                botMessage += delta
            }

            if choice.finishReason != nil {
                // set last GPT answer, so that in "continueConversation" it will be appended and saved to firestore
                self.lastGptAnswer = GptMessage(id: UUID().uuidString, text: botMessage, isFromUser: false, timestamp: .now)
                botMessage = ""
            }
        }
    }

    /// adds a user message to the messages list of the conversation related to the conversationId given in as parameter
    private func addUserMessageToConversation(_ messageText: String, to conversationId: String) {
        let message = GptMessage(id: UUID().uuidString, text: messageText, isFromUser: true, timestamp: .now)
        conversationManager.appendMessageToConversation(message, to: conversationId)
        print("updated in conv. manager \(message)")
    }

    /// updates the selected conversation with a inserted conversation id
    func changeConversation(_ conversationId: String) {
        selectedConversationID = conversationId
    }
    
    func createNewConversation() {
        selectedConversationID = conversationManager.addConversation()
    }
}

// MARK: fetch from / save into firestore
extension GptViewModel {
    /// saves a conversation into firestore
    private func saveConversationToFirestore(id: String, for userId: String) {
        guard let conversation = conversationManager.getConversation(by: id) else { return }

        let conversationRef = firebaseManager.database.collection("gptConversations").document(userId)
            .collection("conversations").document(conversation.id)
        let data = conversationToDict(conversation)

        conversationRef.setData(data, merge: true) { error in
            if let error {
                print("Error saving gpt conversation", error.localizedDescription)
            } else {
                print("conversation successfully saved into firestore")
            }
        }
    }

    /// loads all conversations from firestore and selects the newest conversation id
    private func loadConversations(userId: String) {
        firebaseManager.database.collection("gptConversations").document(userId)
            .collection("conversations")
            .getDocuments { docSnapshots, error in
                if let error {
                    print("Error getting gpt conversation documents", error.localizedDescription)
                    self.createAlert(title: "Error", message: "Failed to load chat gpt conversations. Try again!")
                    return
                }
                let conversations: [GptConversation] = docSnapshots?.documents.compactMap { doc in
                    do {
                        return try doc.data(as: GptConversation.self)
                    } catch {
                        print("Error decoding gpt convo into struct", error.localizedDescription)
                        return nil
                    }
                } ?? []
                self.conversationManager.appendFetchedConversations(conversations)
                // select newest conversation
                if let newestConversation = conversations.max(by: { $0.startDate > $1.startDate }) {
                    self.selectedConversationID = newestConversation.id
                }
            }
    }
}


// MARK: PICKUP LINES
extension GptViewModel {
    /// builds a prompt to send
    func generatePickupLines(user: FireUser, completion: @escaping () -> Void) async {
        isWaitingForBotAnswer = true
        let prompt = buildQueryForUser(user: user)
        let parameters = ChatCompletionParameters(messages: [
            .init(role: .user, content: .text(prompt))
        ], model: .gpt35Turbo)

        do {

            let choices = try await service.startChat(parameters: parameters)
            let answers = choices.choices.map { ($0.message.content ?? "Error message", UUID().uuidString) }
            let first = answers.first?.0 ?? "No message"

            let botAnswers = try parseBotAnswers(from: first)
            DispatchQueue.main.async {
                self.lineOptions = botAnswers
                completion()
            }
        } catch let error as NSError {
            print("Error getting chat choices \(error.localizedDescription), details: \(error.userInfo)")
            errorMessage = Strings.gptError
            completion()
        }
        DispatchQueue.main.async {
            self.isWaitingForBotAnswer = false
        }
    }


    /// parses a bot answer which has different answers in a single string into an array with the seperated answers
    ///  e.g. "1. XYZ"  "2. ABC" " 3. DEF" gets parsed into an array containing each number and string
    private func parseBotAnswers(from text: String) throws -> [GptAnswer] {
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
                return GptAnswer(id: number, message: content)
            }
            return nil
        }
    }


    /// builds a query to send to chat gpt to generate 5 pickup lines,
    /// the prompt contains some details about the user the current user want to message to
    private func buildQueryForUser(user: FireUser) -> String {
        let startPrompt = Strings.gptPrompt
        let interests = user.general.interests?.map { $0.title }.seperated(emptyText: Strings.noInterestsProvided) ?? Strings.noInterestsProvided
        let userInfo = "Userdetails: \(user.nameAgeString) years old, from \(user.location.name). Gender: \(user.gender?.title ?? "Unknown"), Interests: \(interests)"
        let finalPrompt = startPrompt + userInfo
        return finalPrompt
    }
}
