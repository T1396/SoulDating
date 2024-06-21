//
//  PreferencesSection.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 20.06.24.
//

import Foundation

enum PreferencesSection: String, Identifiable, CaseIterable {
    case datingPreferences, lifestylePreferences
    
    typealias Item = PreferencesItem
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .datingPreferences: "Dating Preferences"
        case .lifestylePreferences: "Lifestyle Preferences"
        }
    }
    
    func items(user: User) -> [PreferencesItem] {
        switch self {
        case .datingPreferences:
            return [
                .relationshipType(user.preferences?.relationshipType),
                .preferredGenders(user.preferences?.gender),
                .ageRange(user.preferences?.agePreferences),
                .heightPreference(user.preferences?.height),
                .distancePreference(user.preferences?.distance)
            ]
        case .lifestylePreferences:
            return [
                .smokingPreference(user.preferences?.smoking),
                .drinkingPreferences(user.preferences?.drinking),
                .wantChilds(user.wantChilds),
                .sports(user.preferences?.sports)
            ]
        }
    }
}






