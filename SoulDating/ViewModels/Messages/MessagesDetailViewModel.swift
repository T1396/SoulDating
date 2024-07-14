//
//  MessagesViewModel.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 17.06.24.
//

import Foundation
import Firebase

/// ViewModel  for a single chat
class MessagesDetailViewModel: BaseAlertViewModel {
    // MARK: properties
    private let firebaseManager = FirebaseManager.shared
    private let targetUserId: String
    private var isInitialFetch = true
    private var messageListener: ListenerRegistration?

    // if not nil, there exists a chat already with the targetUser
    var chatId: String?

    @Published var messages: [Message] = []
    @Published var messageContent = ""

    // MARK: init
    init(targetUserId: String, chatId: String?) {
        self.targetUserId = targetUserId
        self.chatId = chatId
        super.init()
        if let chatId {
            resetUnreadCount()
            if messageListener == nil {
                listenForNewMessages(chatId: chatId)
            }
        } else {
            observeChatCreation()
        }
    }


    // MARK: computed properties
    var sendDisabled: Bool {
        messageContent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private func resetUnreadCount() {
        guard let userId = firebaseManager.userId, let chatId else { return }
        print("reset unread count")
        print(chatId)
        firebaseManager.database.collection("chats").document(chatId)
            .setData(["unreadCount": [userId: 0]], merge: true) { error in
                if let error {
                    print("Error updating unread count", error.localizedDescription)
                    return
                }

                print("successfully updated unread count")
            }
    }

    /// observed for new incoming chats for the case there is no existing chat in the actual MessagesView
    /// e.g. when another user sends a message to current user while he is in the View to update the chatId
    private func observeChatCreation() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleNewChatNotification(_:)), name: .newChatReceived, object: nil)
    }

    /// sets the chatId if the chat contains the target userId meaning there was a chatdocument created
    @objc private func handleNewChatNotification(_ notification: Notification) {
        guard let newChat = notification.userInfo?["chat"] as? Chat else { return }
        if messageListener == nil {
            // if the user is in an empty chat with the target that send a chat
            // update the chat id to avoid duplicated chat documents
            if newChat.participantIds.contains(targetUserId), let chatId {
                self.chatId = newChat.id
                listenForNewMessages(chatId: chatId)
            }
        }
    }


    // MARK: functions
    func isFromCurrentUser(_ message: Message) -> Bool {
        message.senderId == firebaseManager.userId
    }

    /// starts a snapshotlistener to get new messages in a specific chat
    private func listenForNewMessages(chatId: String) {
        print("CHATID: \(chatId)")
        messageListener = firebaseManager.database.collection("allMessages")
            .document(chatId).collection("messages")
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { querySnapshot, error in
                if let error {
                    print("ADDSNAPSHOTERROR")
                    // MARK: ....
                    self.createFetchErrorAlert()
                    print("Error fetching messages", error.localizedDescription)
                    return
                }
                var firstAdd = true
                querySnapshot?.documentChanges.forEach { change in
                    switch change.type {
                    case .added:
                        if let newMsg = try? change.document.data(as: Message.self) {
                            self.messages.append(newMsg)
                        } else {
                            print("Error decoding message")
                        }
                        if !firstAdd {
                            self.resetUnreadCount()
                        }
                    case .modified:
                        if let changedMsg = try? change.document.data(as: Message.self) {
                            if let index = self.messages.firstIndex(where: { $0.id == changedMsg.id }) {
                                self.messages[index] = changedMsg
                                self.resetUnreadCount()

                            }
                        }
                    case .removed:
                        if let removedMsg = try? change.document.data(as: Message.self) {
                            if let index = self.messages.firstIndex(where: { $0.id == removedMsg.id }) {
                                self.messages.remove(at: index)
                            }
                        }
                    }
                }
                firstAdd = false
            }
    }
    
    func startListeningForMessages() {
        guard let chatId else { return }
        messages = []
        listenForNewMessages(chatId: chatId)
    }

    func stopListeningForMessages() {
        messageListener?.remove()
        messageListener = nil
    }

    /// calls super function to create an alert a view can listen to
    private func createMessageErrorAlert() {
        createAlert(title: Strings.sendMsgErrorTitle, message: Strings.sendMsgErrorMessage)
    }

    private func createFetchErrorAlert() {
        createAlert(title: Strings.unexpectedErrorTitle, message: Strings.unexpectedErrorTitle)
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

// MARK: CREATE CHAT+MESSAGE / SEND MESSAGE
extension MessagesDetailViewModel {
    /// calls depending on if there already exists a chat functions to update existing chats or create new chats
    /// and sends the message
    func sendMessage() {
        guard let userId = firebaseManager.userId else { return }
        let msg = Message(senderId: userId, receiverId: targetUserId, content: messageContent, timestamp: .now, isRead: false)
        messageContent = ""
        if let chatId {
            self.updateChatAndInsertMessage(chatId, msg)
        } else {
            checkIfChatExists { chatId in
                if let chatId {
                    self.updateChatAndInsertMessage(chatId, msg)
                } else {
                    self.createNewChatAndMessage(userId, msg)
                }
            }
        }
    }

    /// starts a transaction, and creates a chat with metadata of the new message to insert both into firestore
    ///  - Parameters
    ///     - userId - the owner of the chat
    ///     - msg - the new message
    fileprivate func createNewChatAndMessage(_ userId: String, _ msg: Message) {
        createNewChat(userId, msg) { success in
            switch success {
            case .success(let createdChatId):
                self.chatId = createdChatId
                self.uploadMessageToFirestore(msg, chatId: createdChatId) {
                    self.listenForNewMessages(chatId: createdChatId)
                }
            case .failure(let failure):
                print("failed ot create new chat", failure.localizedDescription)
                self.createMessageErrorAlert()
            }
        }
    }


    private func uploadMessageToFirestore(_ msg: Message, chatId: String, completion: @escaping () -> Void) {
       firebaseManager.database.collection("allMessages")
            .document(chatId).collection("messages")
            .addDocument(data: msg.toDict()) { error in
                if let error {
                    print("error uploading message to firestore", error.localizedDescription)
                    self.createMessageErrorAlert()
                    return
                }

                completion()
                print("successfully uploaded message to firestore")
            }
    }
    
    /// created a new chat with meta data like messagecontent etc and uploads it to firestore and returns the chatId to create a message doc for the same id
    /// - Parameter userId : currentUserId
    /// - Parameter msg: the message which is send for creating a new chat
    /// - Parameter completion: completion handler that returns the result with the created chat id if succeeded
    private func createNewChat(_ userId: String, _ msg: Message, completion: @escaping (Result<String, Error>) -> Void) {
        let chatRef = firebaseManager.database.collection("chats").document()
        let unreadCountDict = [targetUserId: 1] // sets count for unread messages to the target user
        let participantKey = getParticipantKey(userId: userId)
        let chat = Chat(
            participantKey: participantKey,
            participantIds: [userId, targetUserId],
            unreadCount: unreadCountDict,
            lastMessageContent: msg.content,
            lastMessageTimestamp: .now,
            lastMessageSenderId: userId
        )
        chatRef.setData(chat.toDict(lastSenderId: userId)) { error in
            if let error {
                print("Error creating chat document", error.localizedDescription)
                completion(.failure(error))
                return
            }
            print("successfully created chat")
            completion(.success(chatRef.documentID))
        }
    }
}

// MARK: UPDATE
extension MessagesDetailViewModel {
    /// starts a transaction to update an existing chat, updates the metadata of the actual chat and
    /// inserts the message into firestore
    fileprivate func updateChatAndInsertMessage(_ chatId: String, _ msg: Message) {
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

        }, completion: { _, error in
            if let error {
                print("Send Message transaction failed", error.localizedDescription)
                self.createMessageErrorAlert()
            } else {
                print("Send Message transaction successfully committed")
                self.messageContent = ""
            }
        })
    }
}
