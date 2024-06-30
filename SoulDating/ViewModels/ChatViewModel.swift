//
//  MessagesListViewModel.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 17.06.24.
//

import Foundation
import Firebase

struct UserDetail: Codable {
    let id: String
    let name: String
    let profileImageUrl: String
}


/// viewModel for all chats with other users
class ChatViewModel: BaseAlertViewModel {
    // MARK: properties
    private let firebaseManager = FirebaseManager.shared
    private var listener: ListenerRegistration?
    
    private var chats: [Chat] = [] {
        didSet {
            fetchUserDetails()
        }
    }
    @Published var chatUserDetails: [Chat: UserDetail] = [:]
    
    // MARK: computed properties
    var userId: String? {
        firebaseManager.userId
    }
    // MARK: init
    override init() {
        super.init()
        listenForChats()
//        let sampleChatUserDetails: [Chat: UserDetail] = [
//            sampleChats[0]: sampleUserDetails[1], // Chat1 mit Bob
//            sampleChats[1]: sampleUserDetails[2], // Chat2 mit Charlie
//            sampleChats[2]: sampleUserDetails[2]  // Chat3 mit Charlie
//        ]
//        self.chatUserDetails = sampleChatUserDetails
    }
    
    
    let sampleChats: [Chat] = [
        Chat(id: "chat1", participantKey: "1", participantIds: ["user1", "user2"], unreadCount: ["user1": 3, "user2": 0], lastMessageContent: "Hey, how are you?", lastMessageTimestamp: Date(), lastMessageSenderId: "user1"),
        Chat(id: "chat1", participantKey: "2", participantIds: ["user1", "user2"], unreadCount: ["user1": 3, "user2": 0], lastMessageContent: "Hey, how are you?", lastMessageTimestamp: Date(), lastMessageSenderId: "user1"),
        Chat(id: "chat1", participantKey: "3", participantIds: ["user1", "user2"], unreadCount: ["user1": 3, "user2": 0], lastMessageContent: "Hey, how are you?", lastMessageTimestamp: Date(), lastMessageSenderId: "user1"),
        Chat(id: "chat1", participantKey: "4", participantIds: ["user1", "user2"], unreadCount: ["user1": 3, "user2": 0], lastMessageContent: "Hey, how are you?", lastMessageTimestamp: Date(), lastMessageSenderId: "user1")
    ]
    
    let sampleUserDetails: [UserDetail] = [
        UserDetail(id: "user1", name: "Alice", profileImageUrl: "https://example.com/alice.jpg"),
        UserDetail(id: "user2", name: "Bob", profileImageUrl: "https://example.com/bob.jpg"),
        UserDetail(id: "user3", name: "Charlie", profileImageUrl: "https://example.com/charlie.jpg")
    ]

    
    
    // MARK: functions
    func fetchAndReturnUser(userId: String, completion: @escaping (User?) -> Void) {
        firebaseManager.database.collection("users").document(userId)
            .getDocument { docSnapshot, error in
                if let error {
                    print("Failed to fetch user", error.localizedDescription)
                    completion(nil)
                }
                do {
                    let user = try docSnapshot?.data(as: User.self)
                    completion(user)
                } catch {
                    print("ChatViewModel - Error decoding user into struct", error.localizedDescription)
                    completion(nil)
                }
            }
    }
    
    
    /// starts a snapshotlistener to get chat updates
    private func listenForChats() {
        guard let userId = firebaseManager.userId else { return }
        listener = firebaseManager.database.collection("chats")
            .whereField("participantIds", arrayContains: userId)
            .addSnapshotListener { [weak self] querySnapshot, error in
                guard let querySnapshot else {
                    print("Error listening for chat updates", error?.localizedDescription ?? "Unknown error")
                    return
                }
                
                querySnapshot.documentChanges.forEach { change in
                    switch change.type {
                    case .added:
                        if let newChat = try? change.document.data(as: Chat.self) {
                            self?.chats.append(newChat)
                            self?.showOverlayWithMessage(message: newChat.lastMessageContent)
                        }
                    case .modified:
                        let chat = try? change.document.data(as: Chat.self)
                        if let chat, let oldIndex = self?.chats.firstIndex(where: { $0.id == chat.id }) {
                            self?.chats[oldIndex] = chat
                            if chat.unreadCount[userId, default: 0] > 0 {
                                self?.showOverlayWithMessage(message: chat.lastMessageContent)
                            }
                        }
                    case .removed:
                        if let index = self?.chats.firstIndex(where: { $0.id == change.document.documentID }) {
                            self?.chats.remove(at: index)
                        }
                    }

                }
            }
    }
    
    /// creates a list of all userIds of the chats and loads details like imageUrl and name for every user
    private func fetchUserDetails() {
        var userIds: Set<String> = Set(chats.compactMap { $0.participantIds.first(where: { $0 != userId }) })
        // only load details for users that are not already loaded
        let alreadyLoadedIds = chatUserDetails.map { $0.value.id }
        userIds = userIds.subtracting(alreadyLoadedIds)
        if !userIds.isEmpty { // only if there are existing chats
            loadUserDetailsForChats(for: Array(userIds))
        }
    }
    
    /// loads user details for every chat from firestore to create a map of containing chat to user,
    /// with helper function mapDetailsToChats
    /// - Parameters:
    /// - userIds - the ids of all users the current users has associated chats with
    private func loadUserDetailsForChats(for userIds: [String]) {
        firebaseManager.database.collection("users")
            .whereField("id", in: userIds)
            .getDocuments { [weak self] querySnapshot, error in
                if let error {
                    print("Error while fetching for profile image urls", error.localizedDescription)
                    return
                }
                
                var details: [UserDetail] = []
                querySnapshot?.documents.forEach { doc in
                    do {
                        let detail = try doc.data(as: UserDetail.self)
                        details.append(detail)
                    } catch {
                        print("Error decoding user document into 'UserDetail' struct" , error.localizedDescription)
                    }
                }
                
                let chatUserDict = self?.mapDetailsToChats(details: details)
                self?.chatUserDetails = chatUserDict ?? [:]
            }
    }
    
    /// accepts a list of user details (name, id, imageUrl) to loop through every user  to find the corresponding chat
    /// and fills a dictionary with every chat and userDetail that is returned
    func mapDetailsToChats(details: [UserDetail]) -> [Chat: UserDetail] {
        var chatUserDetails: [Chat: UserDetail] = [:]
        details.forEach { userDetail in
            if let chat = findChat(for: userDetail.id) {
                chatUserDetails[chat] = userDetail
            }
        }
        return chatUserDetails
    }
    
    
    /// accepts a userId and returns the corresponding chat or nil if not found
    private func findChat(for userId: String) -> Chat? {
        chats.first(where: { $0.participantIds.contains([userId])})
    }
    
    /// accepts a userId and returns the chatId for that chat with that user, and if not found nil
    func returnChatIdIfExists(for targetId: String) -> String? {
        chats.first(where: { $0.participantIds.contains(targetId) })?.id
    }
    
}
