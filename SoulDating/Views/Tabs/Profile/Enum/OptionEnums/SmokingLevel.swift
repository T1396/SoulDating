//
//  SmokingLevel.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 15.06.24.
//

import Foundation

enum SmokeLevel: String, EditableItem, CaseIterable, Codable, Identifiable, Equatable {
    case nonSmoker, occasional, social, regular, heavy, chainSmoker
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .nonSmoker: Strings.nonSmoker
        case .occasional: Strings.occasionalSmoker
        case .social: Strings.socialSmoker
        case .regular: Strings.regularSmoker
        case .heavy: Strings.heavySmoker
        case .chainSmoker: Strings.chainSmoker
        }
    }
    
    
    var icon: String {
        switch self {
        case .nonSmoker: "nosign"
        case .occasional: "smoke.fill"
        case .social: "person.2.wave.2.fill"
        case .regular: "flame.fill"
        case .heavy: "smoke"
        case .chainSmoker: "tornado"
        }
    }
}
