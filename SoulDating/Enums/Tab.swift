//
//  Tab.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 09.06.24.
//

import Foundation
import SwiftUI

enum Tab: String, CaseIterable, Identifiable {
    case swipe, likes, messages, radar, profile
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .swipe: "Swipe"
        case .likes: "Likes"
        case .messages: "Messages"
        case .radar: "Radar"
        case .profile: "Profile"
        }
    }
    
    var icon: String {
        switch self {
        case .swipe:
            "rectangle.portrait.on.rectangle.portrait.angled.fill"
        case .likes:
            "heart.fill"
        case .messages:
            "ellipsis.message.fill"
        case .radar:
            "target"
        case .profile:
            "person.fill"
        }
    }
    
    @ViewBuilder
    func view(user: User) -> some View {
        switch self {
        case .swipe: SwipeView(user: user)
        case .likes: LikesView(user: user)
        case .messages: ChatsView()
        case .radar: RadarView(user: user)
        case .profile: ProfileView(user: user)
        }
    }
}
