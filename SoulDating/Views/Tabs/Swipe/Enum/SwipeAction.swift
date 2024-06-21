//
//  SwipeAction.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 13.06.24.
//

import Foundation

/// enum for all possible swipe actions in the swipe view
enum SwipeAction: String, CaseIterable, Identifiable {
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
        
        print("Width: \(dragAmount.width), Height. \(dragAmount.height)")
        switch (dragAmount.width, dragAmount.height) {
        case (let x, _) where x > horizontalTreshold:
            return .like
        case (let x, _) where x < -horizontalTreshold:
            return .dislike
        case (_, let y) where y < verticalTreshold:
            return .superlike
        default:
            return nil
        }
    }
}
