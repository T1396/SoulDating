//
//  DrinkingBehaviour.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 20.06.24.
//

import Foundation

enum DrinkingBehaviour: String, EditableItem, CaseIterable, Codable {
    case nonDrinker, socialDrinker, regularDrinker
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .nonDrinker: "Non-Drinker"
        case .socialDrinker: "Social Drinker"
        case .regularDrinker: "Regular Drinker"
        }
    }
    
    var icon: String {
        switch self {
        case .nonDrinker: "drop.degreesign.slash.fill"
        case .socialDrinker: "drop.halffull"
        case .regularDrinker: "drop.degreesign.fill"
        }
    }
}
