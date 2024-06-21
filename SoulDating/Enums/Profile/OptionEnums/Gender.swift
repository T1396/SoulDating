//
//  Gender.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 05.06.24.
//

import Foundation

enum Gender: String, EditableItem, Codable, Identifiable, CaseIterable {
    case male, female, divers
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .male: "Male"
        case .female: "Female"
        case .divers: "Divers"
        }
    }
    
    var secTitle: String {
        switch self {
        case .male: "Men"
        case .female: "Woman"
        case .divers: "Non-Binary"
        }
    }
    
    var icon: String {
        switch self {
        case .male, .female, .divers: ""
        }
    }
}

extension Gender {
    static func randomGender() -> Gender {
        return Gender.allCases.randomElement() ?? .divers
    }
}
