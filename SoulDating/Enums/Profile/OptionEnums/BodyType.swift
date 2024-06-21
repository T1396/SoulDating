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
        case .slim: "Slim"
        case .average: "Average"
        case .athletic: "Athletic"
        case .heavyset: "Heavyset"
        }
    }

    // Description for each body type
    var description: String {
        switch self {
        case .slim: "A narrow and slender build."
        case .average: "A generally typical body build, neither notably slim nor particularly bulky."
        case .athletic: "A sporty and muscular build."
        case .heavyset: "A bulkier and broader body build."
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
