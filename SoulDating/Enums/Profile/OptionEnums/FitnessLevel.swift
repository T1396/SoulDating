//
//  FitnessLevel.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 20.06.24.
//

import Foundation

enum FitnessLevel: String, EditableItem, Identifiable, CaseIterable, Codable {
    case unfit, lightly, moderateActive, veryActive, athlete
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .unfit: "Very rarely"
        case .lightly: "Sometimes"
        case .moderateActive: "Regularly doing Sports"
        case .veryActive: "Daily doing Sports"
        case .athlete: "Professional sportsman"
        }
    }
    
    var icon: String {
        switch self {
        case .unfit: "figure.stand"
        case .lightly: "figure.walk"
        case .moderateActive: "figure.run"
        case .veryActive: "gym.bag.fill"
        case .athlete: "medal.fill"
        }
    }
}
