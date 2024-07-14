//
//  MessagesListViewModel.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 17.06.24.
//

import Foundation
import Combine
import Firebase

/// viewModel for all chats with other users
class MessagesViewModel: BaseAlertViewModel {
    // MARK: properties
    private let firebaseManager = FirebaseManager.shared
    private let chatService: ChatService
    
    @Published private (set) var finishedLoading = false

    @Published private (set) var chatDetails: [(chat: Chat, userDetail: UserDetail)] = []
    // holds the number of unread messages for each chatId
    @Published private (set) var unreadMessagesForChats: [String: Int] = [:]
    @Published private (set) var fetchErrorOccured = false
    private var cancellables = Set<AnyCancellable>()


    // MARK: computed properties

    // MARK: init
    init(chatService: ChatService = .shared) {
        self.chatService = chatService
        super.init()
    }

    // MARK: functions
    
    // returns the unread messages count for a specific chat
    func getUnreadCount(chat: Chat) -> Int? {
        if let userId = firebaseManager.userId {
            return chat.unreadCount[userId]
        }
        return nil
    }


    // fetches a user with a userId from firestore calls completion with the user or nil if not existing
    func fetchAndReturnUser(userId: String, completion: @escaping (FireUser?) -> Void) {
        firebaseManager.database.collection("users").document(userId)
            .getDocument { docSnapshot, error in
                if let error {
                    print("Failed to fetch user", error.localizedDescription)
                    self.fetchErrorOccured = true
                    completion(nil)
                }
                do {
                    let user = try docSnapshot?.data(as: FireUser.self)
                    completion(user)
                } catch {
                    print("ChatViewModel - Error decoding user into struct", error.localizedDescription)
                    completion(nil)
                }
            }
    }

    /// accepts a userId and returns the chatId for that chat with that user, and if not found nil
    func returnChatIdIfExists(for targetId: String) -> String? {
        chatDetails.first(where: { $0.chat.participantIds.contains(targetId) })?.chat.id
    }


    /// called when c
    func subscribe() {
        chatDetails = chatService.chatDetails
        unreadMessagesForChats = chatService.unreadMessagesForChats
        finishedLoading = true

        chatService.$chatDetails
            .compactMap { $0 }
            .sink { [weak self] chatDetails in
                self?.chatDetails = chatDetails
            }
            .store(in: &cancellables)
        chatService.$unreadMessagesForChats
            .compactMap { $0 }
            .sink { [weak self] unreadMessagesForChats in
                self?.unreadMessagesForChats = unreadMessagesForChats
            }
            .store(in: &cancellables)
    }

    func unsubscribe() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        finishedLoading = false
    }
}
