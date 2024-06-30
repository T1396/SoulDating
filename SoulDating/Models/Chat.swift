//
//  Chat.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 27.06.24.
//

import Foundation
import FirebaseFirestoreSwift

struct Chat: Codable, Identifiable, Equatable, Hashable {
    @DocumentID var id: String?
    var participantKey: String
    var participantIds: [String]
    // dictionary with userid as key to detect unread messages count
    var unreadCount: [String: Int]
    var lastMessageContent: String
    var lastMessageTimestamp: Date
    var lastMessageSenderId: String
}

extension Chat {
    /// creates a dictionary to insert into firestore, accepts the lastSenderId for the Chat Metadata
    func toDict(lastSenderId: String) -> [String: Any] {
        let dict: [String: Any] = [
            "participantIds": participantIds,
            "participantKey": participantKey,
            "unreadCount": unreadCount,
            "lastMessageContent": lastMessageContent,
            "lastMessageTimestamp": lastMessageTimestamp,
            "lastMessageSenderId": lastSenderId
        ]
        return dict
    }
}
