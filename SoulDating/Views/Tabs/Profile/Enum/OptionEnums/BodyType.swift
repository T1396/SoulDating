//
//  BodyType.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 20.06.24.
//

import Foundation

enum BodyType: String, EditableItem, CaseIterable, Identifiable, Codable {
    case slim, average, athletic, heavyset
    
    var id: String { rawValue }

    // Title for each body type
    var title: String {
        switch self {
        case .slim: Strings.slimBody
        case .average: Strings.avgBody
        case .athletic: Strings.athleticBody
        case .heavyset: Strings.heavysetBody
        }
    }

    var icon: String {
        switch self {
        case .slim: "figure.walk"
        case .average: "person.fill"
        case .athletic: "figure.core.training"
        case .heavyset: "scalemass.fill"
        }
    }
}
