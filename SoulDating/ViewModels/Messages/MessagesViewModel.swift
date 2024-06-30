//
//  MessagesViewModel.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 17.06.24.
//

import Foundation
import Firebase

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
        super.init()
        print("CHATID: \(chatId)")
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
    
    /// starts a snapshotlistener to get new messages in a specific chat
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
                    do {
                        return try doc.data(as: Message.self)
                    } catch {
                        print("Error decoding message from firestore into struct", error.localizedDescription)
                        return nil
                    }
                } ?? []
                self.isInitialized = true
                print("Successfully converted messages")
                print("Messages: \(self.messages)")
            }
    }
    
    /// calls super function to create an alert a view can listen to
    private func createMessageErrorAlert() {
        createAlert(title: sendMessageErrorTitle, message: sendMessageErrorMsg)
    }
    
    /// creates a key containing user and target seperated with ":", sorted
    /// so that only 1 document for a chat is needed
    private func getParticipantKey(userId: String) -> String {
        [userId, targetUserId].sorted().joined(separator: ":")
    }
    
    /// checks if a chat between the current user and the selected user exists to create a new chat if not
    private func checkIfChatExists(completion: @escaping (String?) -> Void) {
        guard let userId = firebaseManager.userId else {
            completion(nil)
            return
        }
        // contains both userIds
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

// MARK: CREATE / SEND MESSAGE
extension MessagesViewModel {
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
    
    /// starts a transaction, and creates a chat with metadata of the new message to insert both into firestore
    ///  - Parameters
    ///     - userId - the owner of the chat
    ///     - msg - the new message
    fileprivate func createNewChatAndMessage(_ userId: String, _ msg: Message) {
        // no chat existing, create and upload a new one with the actual message
        let chatRef = firebaseManager.database.collection("chats").document()
        let messageRef = firebaseManager.database.collection("allMessages").document(chatRef.documentID).collection("messages").document()
        
        let unreadCountDict = [targetUserId: 1] // sets count for unread messages to the target user
        let participantKey = getParticipantKey(userId: userId)
        let chat = Chat(participantKey: participantKey, participantIds: [userId, targetUserId], unreadCount: unreadCountDict, lastMessageContent: msg.content , lastMessageTimestamp: .now, lastMessageSenderId: userId)
       
        firebaseManager.database.batch()
        firebaseManager.database.runTransaction({ transaction, error in
            transaction.setData(chat.toDict(lastSenderId: userId), forDocument: chatRef)
            transaction.setData(msg.toDict(), forDocument: messageRef)
            return nil
        }) { object, error in
            if let error {
                print("Send message transaction failed while creating new chat", error.localizedDescription)
                self.createMessageErrorAlert()
            } else {
                print("Successfully created chat with the provided message: \(msg)")
                self.chatId = chatRef.documentID
                self.messages.append(msg)
                self.messageContent = ""
            }
        }
    }
}

// MARK: UPDATE
extension MessagesViewModel {
    /// starts a transaction to update an existing chat, updates the metadata of the actual chat and
    /// inserts the message into firestore
    fileprivate func updateExistingChat(_ chatId: String, _ msg: Message) {
        // update existing chat
        let chatRef = firebaseManager.database.collection("chats")
            .document(chatId)
        let messageRef = firebaseManager.database.collection("allMessages").document(chatId)
            .collection("messages").document()
        
        firebaseManager.database.runTransaction({ transaction, error in
    
            let chatDoc: DocumentSnapshot
            do {
                try chatDoc = transaction.getDocument(chatRef)
            } catch let fetchError as NSError {
                error?.pointee = fetchError
                return nil
            }

            // add message
            transaction.setData(msg.toDict(), forDocument: messageRef)
            // update chat meta data
            transaction.updateData([
                "lastMessageContent": msg.content,
                "lastMessageTimestamp": msg.timestamp,
                "lastMessageSenderId": msg.senderId
            ], forDocument: chatRef)
            
            // increment unread count for the target(s)
            if let participants = chatDoc.data()?["participantIds"] as? [String] {
                for participant in participants where participant != msg.senderId {
                    // the path to the unread count of the user
                    let unreadKey = "unreadCount.\(participant)"
                    let currentUnreadCount = (chatDoc.data()?["unreadCount"] as? [String: Int])?[participant] ?? 0
                    transaction.updateData([unreadKey: currentUnreadCount + 1], forDocument: chatRef)
                }
            }
            return nil // finished
            
        }, completion: { object, error in
            if let error {
                print("Send Message transaction failed", error.localizedDescription)
                self.createMessageErrorAlert()
            } else {
                print("Send Message transaction successfully committed")
                self.messageContent = ""
                self.messages.append(msg)
            }
        })
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
