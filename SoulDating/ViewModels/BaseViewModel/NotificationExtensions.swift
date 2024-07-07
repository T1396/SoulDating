//
//  NotificationCenterExtensions.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 18.06.24.
//

import Foundation

extension Notification.Name {
    static let userDocumentUpdated = Notification.Name("userDocumentUpdated")    
    static let newChatReceived = Notification.Name("newChatReceived")
    static let unreadMsgUpdated = Notification.Name("unreadMsgUpdated")
    static let resetUnreadCount = Notification.Name("resetUnreadCount")
}
