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

struct ChatNotification: Equatable {
    let message: String
    let senderName: String
    let timestamp: Date
    let senderImageUrl: String?
}

/// viewModel for all chats with other users
class ChatViewModel: BaseAlertViewModel {
    // MARK: properties
    private let firebaseManager = FirebaseManager.shared
    private var listener: ListenerRegistration?
    private var isInitialFetch = true
    private var chats: [Chat] = []

    @Published var chatUserDetails: [Chat: UserDetail] = [:]
    @Published var chatDetails: [(chat: Chat, userDetail: UserDetail)] = []
    @Published var unreadMessagesCount = 0
    // holds the number of unread messages for each chatId
    @Published var unreadMessagesForChats: [String: Int] = [:]

    @Published var chatNotification: ChatNotification?

    // MARK: computed properties
    var userId: String? {
        firebaseManager.userId
    }

    // MARK: init
    override init() {
        super.init()
        listenForChats {
            self.isInitialFetch = false
        }
    }

    // MARK: functions

    func getUnreadCount(chat: Chat) -> Int? {
        if let userId {
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
    
    
    /// starts a snapshotlistener to listen for new chats / messages to show e.g. in app notifications
    private func listenForChats(completion: @escaping () -> Void) {
        guard let userId = firebaseManager.userId else { return }
        listener = firebaseManager.database.collection("chats")
            .whereField("participantIds", arrayContains: userId)
            .order(by: "lastMessageTimestamp", descending: true)
            .addSnapshotListener { [weak self] querySnapshot, error in
                guard let querySnapshot else {
                    print("Error listening for chat updates", error?.localizedDescription ?? "Unknown error")
                    return
                }
                querySnapshot.documentChanges.forEach { change in
                    switch change.type {
                    case .added:
                        if let newChat = try? change.document.data(as: Chat.self) {
                            self?.handleNewChat(newChat, self?.isInitialFetch ?? true)
                        } else {
                            print("error decoding chat")
                        }
                    case .modified:
                        print("modified")
                        let chat = try? change.document.data(as: Chat.self)
                        self?.handleNewChatMessage(chat, userId: userId)
                    case .removed:
                        self?.removeChat(change.document.documentID)
                    }
                }
                completion()
                self?.fetchUserDetails()
                self?.updateUnreadMessageCount()
            }
    }
    
    /// appends the newchat to the chat list and notifies other viewmodels for badges etc.
    private func handleNewChat(_ newChat: Chat, _ isInitialFetch: Bool) {
        chats.append(newChat)
        if !isInitialFetch {
            notifyChatUpdate(newChat)
            showIncomingChatOverlay(newChat)
            // showOverlayWithMessage(message: newChat.lastMessageContent)
            updateUnreadMessageCount()
        }
    }
    
    private func showIncomingChatOverlay(_ chat: Chat) {
        getUserNameAndImage(for: chat.lastMessageSenderId) { userName, imageUrl in
            self.chatNotification = ChatNotification(message: chat.lastMessageContent, senderName: userName ?? "Anonymous", timestamp: chat.lastMessageTimestamp, senderImageUrl: imageUrl)
        }
    }

    private func removeChat(_ chatDocumentId: String) {
        if let index = chats.firstIndex(where: { $0.id == chatDocumentId }),
           let detailIndex = chatDetails.firstIndex(where: { $0.chat.id == chatDocumentId }) {
            chats.remove(at: index)
            chatDetails.remove(at: detailIndex)
        }
    }

    private func handleNewChatMessage(_ chat: Chat?, userId: String) {
        if let chat, let index = chats.firstIndex(where: { $0.id == chat.id }) {
            chats[index] = chat
            updateChatInChatDetails(newChat: chat)
            updateUnreadMessageCount()
            
            if chat.unreadCount[userId, default: 0] > 0 {
                showIncomingChatOverlay(chat)
                // showOverlayWithMessage(message: chat.lastMessageContent)
            }
        }
    }

    private func updateUnreadMessageCount() {
        guard let userId = firebaseManager.userId else { return }
        unreadMessagesCount = chats.reduce(0) { $0 + ($1.unreadCount[userId] ?? 0) }
        for chat in chats {
            if let chatId = chat.id, let unreadCount = chat.unreadCount[userId] {
                unreadMessagesForChats[chatId] = unreadCount
            }
        }
    }

    private func updateChatInChatDetails(newChat: Chat) {
        if let index = chatDetails.firstIndex(where: { $0.chat.id == newChat.id }) {
            let userDetail = chatDetails[index].userDetail
            chatDetails[index] = (newChat, userDetail)
            sortChatDetails()
        }
    }

    /// sends a notification to MessagesViewModel when new chat was found,  for the case when it has no chatid because there was no chat and another user wrote a message to him to update the chatId
    private func notifyChatUpdate(_ chat: Chat) {
        NotificationCenter.default.post(name: .newChatReceived, object: self, userInfo: ["chat": chat])
    }

    /// creates a list of all userIds of the chats and loads details like imageUrl and name for every user
    private func fetchUserDetails() {
        print("fetched user details")
        var userIds: Set<String> = Set(chats.compactMap { $0.participantIds.first(where: { $0 != userId }) })
        // only load details for users that are not already loaded
        let alreadyLoadedIds = chatDetails.map { $0.userDetail.id }
        userIds = userIds.subtracting(alreadyLoadedIds)
        if !userIds.isEmpty { // only if there are existing chats
            loadUserDetailsForChats(for: Array(userIds))
        }
    }

    private func getUserNameAndImage(
        for userId: String,
        completion: @escaping (_ userName: String?, _ imageUrl: String?) -> Void) {
        firebaseManager.database.collection("users").document(userId)
            .getDocument { docSnapshot, error in
                if let error {
                    print("Error getting user image url", error.localizedDescription)
                    completion(nil, nil)
                    return
                }

                let imageUrl = docSnapshot?.data()?["profileImageUrl"] as? String
                let userName = docSnapshot?.data()?["name"] as? String ?? "Error"
                completion(userName, imageUrl)
            }
    }

    private func sortChatDetails() {
        chatDetails = Array(chatDetails.sorted(by: { $0.chat.lastMessageTimestamp > $1.chat.lastMessageTimestamp }))
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
                
                let userDetails = querySnapshot?.documents.compactMap { doc -> UserDetail? in
                    do {
                        return try doc.data(as: UserDetail.self)
                    } catch {
                        print("Error decoding user document into UserDetail struct", error.localizedDescription)
                        return nil
                    }
                } ?? []
                let chatUserList = self?.createChatUserList(details: userDetails) ?? []
                self?.chatDetails.append(contentsOf: chatUserList)
                self?.sortChatDetails()
            }
    }
    

    private func createChatUserList(details: [UserDetail]) -> [(chat: Chat, userDetail: UserDetail)] {
        var chatUserList: [(chat: Chat, userDetail: UserDetail)] = []
        details.forEach { userDetail in
            if let chat = findChat(for: userDetail.id) {
                chatUserList.append((chat, userDetail))
            }
        }
        return chatUserList
    }

    /// accepts a userId and returns the corresponding chat or nil if not found
    private func findChat(for userId: String) -> Chat? {
        chats.first(where: { $0.participantIds.contains([userId]) })
    }
    
    /// accepts a userId and returns the chatId for that chat with that user, and if not found nil
    func returnChatIdIfExists(for targetId: String) -> String? {
        chats.first(where: { $0.participantIds.contains(targetId) })?.id
    }
    
}
