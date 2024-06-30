//
//  Message.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 17.06.24.
//

import Foundation
import FirebaseFirestoreSwift

struct Message: Codable, Identifiable {
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



extension Message {
    /// creates a dictionary of the message to insert into firestore
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
