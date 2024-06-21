//
//  MessagesViewModel.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 17.06.24.
//

import Foundation

/// implements BaseAlertViewModel for Alert und Result Managing
class MessagesViewModel: BaseAlertViewModel {
    // MARK: properties
    private let firebaseManager = FirebaseManager.shared

    @Published var messages: [Message] = [] {
        didSet {
            print(messages)
        }
    }
    @Published var messageContent = ""
    
    // if not nil, there exists a chat already with the targetUser
    var chatId: String? = nil
    private let targetUserId: String
    private var isInitialized = false
    
    // MARK: init
    init(targetUserId: String, chatId: String?) {
        self.targetUserId = targetUserId
        self.chatId = chatId
        print("ChatID: \(chatId)")
        super.init()
        if let chatId {
            listenForNewMessages(chatId: chatId)
        }
    }
    
    // MARK: computed properties
    var sendDisabled: Bool {
        messageContent.isEmpty
    }
    
    // MARK: functions
    func isFromCurrentUser(_ message: Message) -> Bool {
        message.senderId == firebaseManager.userId
    }
    
    private func listenForNewMessages(chatId: String) {
        print("listen started")
        firebaseManager.database.collection("allMessages")
            .document(chatId).collection("messages")
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { querySnapshot, error in
                if let error {
                    self.createAlert(title: self.unexpectedErrorTitle, message: self.unexpectedErrorMsg)
                    print("Error fetching messages", error.localizedDescription)
                    return
                }
                
                self.messages = querySnapshot?.documents.compactMap { doc in
                    try? doc.data(as: Message.self)
                } ?? []
                self.isInitialized = true
                print("Successfully converted messages")
                print("Messages: \(self.messages)")
            }
    }
    
    /// starts a transaction to update an existing chat, updates the metadata of the actual chat and
    /// inserts the message into firestore
    fileprivate func updateExistingChat(_ chatId: String, _ msg: Message) {
        // update existing chat
        let chatRef = firebaseManager.database.collection("chats")
            .document(chatId)
        let messageRef = firebaseManager.database.collection("allMessages").document(chatId)
            .collection("messages").document()
        
        firebaseManager.database.runTransaction({ transaction, error in
            // add message
            transaction.setData(msg.toDict(), forDocument: messageRef)
            // update chat meta data
            transaction.updateData([
                "lastMessageContent": msg.content,
                "lastMessageTimestamp": msg.timestamp,
                "lastMessageSenderId": msg.senderId
            ], forDocument: chatRef)
            return nil // finished
            
            
        }, completion: { object, error in
            if let error {
                print("Send Message transaction failed", error.localizedDescription)
                self.createMessageErrorAlert()
            } else {
                print("Send Message transaction successfully committed")
                self.messageContent = ""
            }
        })
    }
    
    /// starts a transaction, and creates a chat with metadata of the new message to insert both into firestore
    ///  - Parameters
    ///     - userId - the owner of the chat
    ///     - msg - the new message
    fileprivate func createNewChatAndMessage(_ userId: String, _ msg: Message) {
        // no chat existing, create and upload a new one with the actual message
        let chatRef = firebaseManager.database.collection("chats").document()
        let messageRef = firebaseManager.database.collection("allMessages").document(chatRef.documentID).collection("messages").document()
        
        let participantKey = getParticipantKey(userId: userId)
        let chat = Chat(participantKey: participantKey, participantIds: [userId, targetUserId], lastMessageContent: msg.content, lastMessageTimestamp: .now, lastMessageSenderId: userId)
        firebaseManager.database.runTransaction({ transaction, error in
            transaction.setData(chat.toDict(lastSenderId: userId), forDocument: chatRef)
            transaction.setData(msg.toDict(), forDocument: messageRef)
            return nil
        }) { object, error in
            if let error {
                print("Send message transaction failed", error.localizedDescription)
                self.createMessageErrorAlert()
            } else {
                print("Successfully created chat with the provided message: \(msg)")
                self.chatId = chatRef.documentID
                self.messageContent = ""
            }
        }
    }
    
    /// calls depending on if there already exists a chat functions to update existing chats or create new chats
    func sendMessage() {
        guard let userId = firebaseManager.userId else { return }
        let msg = Message(senderId: userId, receiverId: targetUserId, content: messageContent, timestamp: .now, isRead: false)
        checkIfChatExists { chatId in
            if let chatId {
                self.updateExistingChat(chatId, msg)
            } else {
                self.createNewChatAndMessage(userId, msg)
            }
        }
    }
    
    /// calls super function to create an alert a view can listen to
    private func createMessageErrorAlert() {
        createAlert(title: sendMessageErrorTitle, message: sendMessageErrorMsg)
    }
    
    func getParticipantKey(userId: String) -> String {
        [userId, targetUserId].sorted().joined(separator: ":")
    }
    
    private func checkIfChatExists(completion: @escaping (String?) -> Void) {
        guard let userId = firebaseManager.userId else {
            completion(nil)
            return
        }
        let participantKey = getParticipantKey(userId: userId)
        firebaseManager.database.collection("chats")
            .whereField("participantKey", isEqualTo: participantKey)
            .getDocuments { querySnapshot, error in
                if let error {
                    print("error getting documents", error.localizedDescription)
                    completion(nil)
                    return
                }
                if let snapshot = querySnapshot, let chatDoc = snapshot.documents.first {
                    // chat exists already
                    completion(chatDoc.documentID)
                } else {
                    completion(nil)
                }
            }
    }
}


// MARK: error messages
extension MessagesViewModel {
    var sendMessageErrorTitle: String {
        "Could not push your message"
    }
    var sendMessageErrorMsg: String {
        "Please try it again or otherwise report a bug."
    }
    
    var unexpectedErrorTitle: String {
        "There was an unexpected error..."
    }
    var unexpectedErrorMsg: String {
        "The messages could not be found, please retry or report a bug."
    }
}
