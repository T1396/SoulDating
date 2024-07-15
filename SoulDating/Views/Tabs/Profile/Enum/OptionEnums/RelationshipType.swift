//
//  RelationshipType.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 20.06.24.
//

import Foundation

enum RelationshipType: String, EditableItem, Identifiable, CaseIterable, Codable {
    case friendship, undefined, dating, longTerm
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .friendship: Strings.relationshipFriendships
        case .undefined: Strings.relationshipUndefined
        case .dating: Strings.relationshipDating
        case .longTerm: Strings.relationshipLongTerm
        }
    }
    
    var icon: String {
        switch self {
        case .friendship: "person.2.fill"
        case .undefined: "questionmark.circle"
        case .dating: "heart.circle.fill"
        case .longTerm: "house.fill"
        }
    }
}
