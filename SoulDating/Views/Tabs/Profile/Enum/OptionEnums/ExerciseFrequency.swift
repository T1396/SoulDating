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
        case .never: Strings.never
        case .occasionally: Strings.occasionally
        case .regularly: Strings.regularly
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
