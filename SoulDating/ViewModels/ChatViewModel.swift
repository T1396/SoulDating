//
//  MessagesListViewModel.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 17.06.24.
//

import Foundation

struct UserDetail: Codable {
    let id: String
    let name: String
    let profileImageUrl: String
}
/// viewModel for all chats with other users
class ChatViewModel: BaseAlertViewModel {
    
    let sampleChats: [Chat] = [
        Chat(id: "chat1", participantKey: "key1", participantIds: ["user1", "user2"], lastMessageContent: "Hey, how are you?", lastMessageTimestamp: Date(), lastMessageSenderId: "user1"),
        Chat(id: "chat2", participantKey: "key2", participantIds: ["user1", "user3"], lastMessageContent: "Are we meeting tomorrow?", lastMessageTimestamp: Date(), lastMessageSenderId: "user3"),
        Chat(id: "chat3", participantKey: "key3", participantIds: ["user2", "user3"], lastMessageContent: "Don't forget the meeting.", lastMessageTimestamp: Date(), lastMessageSenderId: "user2")
    ]

    let sampleUserDetails: [UserDetail] = [
        UserDetail(id: "user1", name: "Alice", profileImageUrl: "https://example.com/alice.jpg"),
        UserDetail(id: "user2", name: "Bob", profileImageUrl: "https://example.com/bob.jpg"),
        UserDetail(id: "user3", name: "Charlie", profileImageUrl: "https://example.com/charlie.jpg")
    ]

    
    
    // MARK: functions
    private let firebaseManager = FirebaseManager.shared
    
    @Published var chats: [Chat] = [] {
        didSet {
            print("Neue Chats: \(chats)")
            fetchUserDetails()
        }
    }
    @Published var chatUserDetails: [Chat: UserDetail] = [:]
    
    var userId: String? {
        firebaseManager.userId
    }
    
    func fetchAndReturnUser(userId: String, completion: @escaping (User) -> Void) {
        print("Started fetching user: \(userId)")
        firebaseManager.database.collection("users")
            .whereField("id", isEqualTo: userId)
            .getDocuments { querySnapshot, error in
                if let error {
                    print("Error while fetching user in chat view model", error.localizedDescription)
                    return
                }
                
                guard let querySnapshot = querySnapshot, let document = querySnapshot.documents.first else {
                    print("User does not exist")
                    self.createAlert(title: "Error", message: "The user could not be found.")
                    return
                }
                
                do {
                    let user = try document.data(as: User.self)
                    completion(user)
                } catch {
                    print("Decoding user failed (chatViewModel)", error.localizedDescription)
                }
            }
    }
    
    // MARK: init
    override init() {
        super.init()
        fetchChats { _ in }
//        let sampleChatUserDetails: [Chat: UserDetail] = [
//            sampleChats[0]: sampleUserDetails[1], // Chat1 mit Bob
//            sampleChats[1]: sampleUserDetails[2], // Chat2 mit Charlie
//            sampleChats[2]: sampleUserDetails[2]  // Chat3 mit Charlie
//        ]
//        self.chatUserDetails = sampleChatUserDetails
    }
    
    // MARK: functions
    private func fetchChats(completion: @escaping (Bool) -> Void) {
        guard let userId = firebaseManager.userId else { return }
        print(userId)
        firebaseManager.database.collection("chats")
            .whereField("participantIds", arrayContains: userId)
            .addSnapshotListener { querySnapshot, error in
                if let error {
                    completion(false)
                    print("error with snapshotlistener in 'fetch Chats'", error.localizedDescription)
                    return
                }
                
                guard let chatDocs = querySnapshot?.documents else { return }
                
                self.chats = chatDocs.compactMap { doc in
                    try? doc.data(as: Chat.self)
                }
                completion(true)
            }
    }
    
    /// creates a list of all userIds of the chats and loads details like imageUrl and name for every user
    private func fetchUserDetails() {
        var userIds: Set<String> = Set(chats.compactMap { $0.participantIds.first(where: { $0 != userId }) })
        // only load details for users that are not already loaded
        let alreadyLoadedIds = chatUserDetails.map { $0.value.id }
        userIds = userIds.subtracting(alreadyLoadedIds)
        print("User Ids to fetch User Details for chats: \(userIds)")
        if !userIds.isEmpty { // only if there are existing chats
            loadUserDetailsForChats(for: Array(userIds))
        }
    }
    
    /// loads user details for every chat to connect them
    private func loadUserDetailsForChats(for userIds: [String]) {
        print(userIds)
        firebaseManager.database.collection("users")
            .whereField("id", in: userIds)
            .getDocuments { querySnapshot, error in
                if let error {
                    print("Error while fetching for profile image urls", error.localizedDescription)
                    return
                }
                
                var details: [UserDetail] = []
                querySnapshot?.documents.forEach { doc in
                    do {
                        let detail = try doc.data(as: UserDetail.self)
                        details.append(detail)
                        print("Appended user detail: \(detail)")
                    } catch {
                        print("Error decoding user document into 'UserDetail' struct" , error.localizedDescription)
                    }
                }
                
                let chatDetailDict = self.mapDetailsToChats(details: details)
                self.chatUserDetails = chatDetailDict
                print("\nAppended userdetails: \(details)")
            }
    }
    
    func mapDetailsToChats(details: [UserDetail]) -> [Chat: UserDetail] {
        var chatUserDetails: [Chat: UserDetail] = [:]
        details.forEach { userDetail in
            if let chat = findChat(for: userDetail) {
                chatUserDetails[chat] = userDetail
            }
        }
        return chatUserDetails
    }
    
    func findChat(for userDetail: UserDetail) -> Chat? {
        chats.first(where: { $0.participantIds.contains([userDetail.id])})
    }
    
    func returnChatIdIfExists(for userId: String) -> String? {
        chats.first(where: { $0.participantIds.contains { id in
            id == userId
        }})?.id
    }
}
