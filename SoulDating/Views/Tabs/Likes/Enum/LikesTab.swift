//
//  LikesTab.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 16.07.24.
//

import Foundation

enum LikesTab: String, Identifiable, CaseIterable, Equatable, TabEnum {
    case likes, likedUsers, matches

    var id: String { rawValue }

    var title: String {
        switch self {
        case .likes: Strings.yourLikes
        case .likedUsers: Strings.likedUsers
        case .matches: Strings.matches
        }
    }

    var index: Int {
        switch self {
        case .likes: 0
        case .likedUsers: 1
        case .matches: 2
        }
    }

    var emptyText: String {
        switch self {
        case .likes: Strings.noLikes
        case .likedUsers: Strings.noLikedUsers
        case .matches: Strings.noMatches
        }
    }
}
