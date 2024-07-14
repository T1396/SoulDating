//
//  ChatNotification.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 12.07.24.
//

import Foundation

struct ChatNotification: Equatable {
    let message: String
    let senderName: String
    let timestamp: Date
    let senderImageUrl: String?
}
