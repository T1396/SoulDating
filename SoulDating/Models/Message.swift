//
//  Message.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 17.06.24.
//

import Foundation
import FirebaseFirestoreSwift

struct Message: Codable, Identifiable, Equatable {
    @DocumentID var id: String?
    let senderId: String
    let receiverId: String
    let content: String
    let timestamp: Date
    var isRead: Bool
    
    static func ==(lhs: Message, rhs: Message) -> Bool {
            return lhs.id == rhs.id
        }
}

struct UIChat: Identifiable {
    var id: String
       var participantIds: [String]
       var lastMessageContent: String
       var lastMessageTimestamp: Date
       var lastMessageSenderId: String
       var lastMessageSenderName: String
       var lastMessageSenderImageUrl: String
}

struct Chat: Codable, Identifiable, Equatable, Hashable {
    @DocumentID var id: String?
    var participantKey: String
    var participantIds: [String]
    var lastMessageContent: String
    var lastMessageTimestamp: Date
    var lastMessageSenderId: String
}

extension Message {
    func toDict() -> [String: Any] {
        let dict: [String: Any] = [
            "senderId": senderId,
            "receiverId": receiverId,
            "timestamp": timestamp,
            "content": content,
            "isRead": isRead
        ]
        return dict
    }
}

extension Chat {
    func toDict(lastSenderId: String) -> [String: Any] {
        let dict: [String: Any] = [
            "participantIds": participantIds,
            "lastMessageContent": lastMessageContent,
            "participantKey": participantKey,
            "lastMessageTimestamp": lastMessageTimestamp,
            "lastMessageSenderId": lastSenderId
        ]
        return dict
    }
}
