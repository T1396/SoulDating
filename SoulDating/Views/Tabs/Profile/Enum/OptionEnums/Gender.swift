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
        case .male: Strings.male
        case .female: Strings.female
        case .divers: Strings.divers
        }
    }
    
    var secTitle: String {
        switch self {
        case .male: Strings.maleSecondary
        case .female: Strings.femaleSecondary
        case .divers: Strings.diversSecondary
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
        Gender.allCases.randomElement() ?? .divers
    }
}
