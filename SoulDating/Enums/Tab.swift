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
        case .swipe:
            "Swipes"
        case .likes:
            "Likes"
        case .messages:
            "Nachrichten"
        case .radar:
            "Radar"
        case .profile:
            "Profil"
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
        var view: some View {
            switch self {
            case .swipe: SwipeView()
            case .likes: LikesView()
            case .messages: MessagesView()
            case .radar: RadarView()
            case .profile: ProfileView()
            }
        }
}
