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
        case .nonSmoker: "Non-Smoker"
        case .occasional: "Occasional Smoker"
        case .social: "Social Smoker"
        case .regular: "Regular Smoker"
        case .heavy: "Heavy Smoker"
        case .chainSmoker: "Chain Smoker"
        }
    }
    
    var description: String {
            switch self {
            case .nonSmoker: "Not smoking at all"
            case .occasional: "Occasionally"
            case .social: "Just on parties"
            case .regular: "Regularly"
            case .heavy: "Much"
            case .chainSmoker: "Very frequent"
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
