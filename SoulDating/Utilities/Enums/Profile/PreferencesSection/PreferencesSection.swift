//
//  PreferencesSection.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 20.06.24.
//

import Foundation

enum PreferencesSection: String, Identifiable, CaseIterable {
    case datingPreferences, lifestylePreferences
        
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .datingPreferences: "Dating Preferences"
        case .lifestylePreferences: "Lifestyle Preferences"
        }
    }

    var items: [any AboutYouItemProtocol] {
        switch self {
        case .datingPreferences:
            DatingPreferenceItem.allCases.map { $0 as any AboutYouItemProtocol }
        case .lifestylePreferences:
            LifestylePreferenceItem.allCases.map { $0 as any AboutYouItemProtocol }
        }
    }
}
