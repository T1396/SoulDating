//
//  SwipeAction.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 13.06.24.
//

import Foundation

/// enum for all possible swipe actions in the swipe view
enum SwipeAction: String, CaseIterable, Identifiable, Codable {
    case like, dislike, superlike
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .like: "Like"
        case .dislike: "Dislike"
        case .superlike: "Superlike"
        }
    }
    
    /// gets an input CGSize when a swipe was done and returns the corresponding action
    /// for the direction of the swipe
    static func fromSwipe(dragAmount: CGSize) -> SwipeAction? {
        let horizontalTreshold: CGFloat = 100
        let verticalTreshold: CGFloat = -300
        
        switch (dragAmount.width, dragAmount.height) {
        case (let width, _) where width > horizontalTreshold:
            return .like
        case (let width, _) where width < -horizontalTreshold:
            return .dislike
        case (_, let height) where height < verticalTreshold:
            return .superlike
        default:
            return nil
        }
    }
}
