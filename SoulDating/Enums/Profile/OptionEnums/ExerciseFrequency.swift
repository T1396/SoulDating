//
//  ExerciseFrequency.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 20.06.24.
//

import Foundation

enum ExerciseFrequency: String, EditableItem, CaseIterable {
    case never, occasionally, regularly
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .never: "Never"
        case .occasionally: "Occasionally"
        case .regularly: "Regularly"
        }
    }
    
    var icon: String {
        switch self {
        case .never: "chair.lounge.fill"
        case .occasionally: "figure.run"
        case .regularly: "gym.bag.fill"
        }
    }
}
