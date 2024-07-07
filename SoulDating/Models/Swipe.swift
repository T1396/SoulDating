//
//  File.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 21.06.24.
//

import Foundation

/// swipe action to save in "userActions" document
struct Swipe: Codable {
    let fromUserId: String
    let targetUserId: String
    let action: SwipeAction
    let timestamp: Date
}

/// swipe action to save in "userLikes" to show all users who liked a user
struct UserSwipe: Codable {
    let action: SwipeAction
    let fromUserId: String
    let timestamp: Date
}
