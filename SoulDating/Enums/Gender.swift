//
//  Gender.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 05.06.24.
//

import Foundation

enum Gender: String, Codable, Identifiable, CaseIterable {
    case male, female, divers
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .male: "Männlich"
        case .female: "Weiblich"
        case .divers: "Divers"
        }
    }
    
}

extension Gender {
    static func randomGender() -> Gender {
        return Gender.allCases.randomElement() ?? .divers
    }
}
