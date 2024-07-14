//
//  ChatService.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 08.07.24.
//

import Foundation
import Firebase

/// singleton ChatService to update all chats and setup notifications that are displayed in the navigation view than
class ChatService: BaseAlertViewModel {
    static let shared = ChatService()
    private var isInitialFetch = true
    private let firebaseManager = FirebaseManager.shared
    private var listener: ListenerRegistration?

    var userId: String? {
        firebaseManager.userId
    }

    // MARK: init
    override private init() {
        super.init()
        listenForChats {
            self.isInitialFetch = false
        }
    }

    private var chats: [Chat] = []
    @Published private (set) var chatDetails: [(chat: Chat, userDetail: UserDetail)] = []
    @Published private (set) var unreadMessagesForChats: [String: Int] = [:]
    @Published private (set) var unreadMessagesCount = 0
    @Published var chatNotification: ChatNotification?

    /// starts a snapshotlistener to listen for new chats / messages
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
                        }
                    case .modified:
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
            if newChat.lastMessageSenderId != userId {
                showIncomingChatOverlay(newChat)
            }
        }
    }

    /// fetches username and image to set a chat notification that will be displayed in the UI than
    private func showIncomingChatOverlay(_ chat: Chat) {
        // fetch name and image url from firestore
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

            // ensure user does not get notified with own messages
            if chat.unreadCount[userId, default: 0] > 0 && chat.lastMessageSenderId != userId {
                showIncomingChatOverlay(chat)
            }
        }
    }

    /// updates the unread messages count for each chat that is displayed in the messagesView
    private func updateUnreadMessageCount() {
        guard let userId = firebaseManager.userId else { return }
        unreadMessagesCount = chats.reduce(0) { $0 + ($1.unreadCount[userId] ?? 0) }
        for chat in chats {
            if let chatId = chat.id, let unreadCount = chat.unreadCount[userId] {
                unreadMessagesForChats[chatId] = unreadCount
            }
        }
    }

    /// accepts a newChat to replace it in the chatDetails var
    /// and sorts the updated chatdetails than
    private func updateChatInChatDetails(newChat: Chat) {
        if let index = chatDetails.firstIndex(where: { $0.chat.id == newChat.id }) {
            chatDetails[index].chat = newChat
            sortChatDetails()
        }
    }

    /// sends a notification to MessagesViewModel for the case 2 users open a messageDetailView to each
    /// other  but there is no existing chat document, so that when any users writes a message which
    /// creates the chat document, the other will receive the id of the new chat document to
    /// prevent multiple documents
    private func notifyChatUpdate(_ chat: Chat) {
        NotificationCenter.default.post(name: .newChatReceived, object: self, userInfo: ["chat": chat])
    }

    /// creates a list of all userIds of the chats and loads details like imageUrl and name for every user
    private func fetchUserDetails() {
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
    /// - Parameter userIds - the ids of all users the current users has associated chats with
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

    /// accepts a list of userDetails and returns a list with tuples of the corresponding chat and userDetails concatenated
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
        chatDetails.first(where: { $0.chat.participantIds.contains(targetId) })?.chat.id
    }
}
