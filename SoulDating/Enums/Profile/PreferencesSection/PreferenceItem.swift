//
//  PreferenceItem.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 21.06.24.
//

import Foundation
import SwiftUI

enum PreferencesItem: Identifiable {
    case preferredGenders([Gender]?)
    case ageRange(AgePreference?)
    case heightPreference(Int?)
    case distancePreference(Int?)
    case smokingPreference(Bool?)
    case drinkingPreferences(Bool?)
    case wantChilds(Bool?)
    case sports(Bool?)
    case relationshipType(RelationshipType?)
    
    var id: String { UUID().uuidString }
    
    var title: String {
        switch self {
        case .preferredGenders: "Your preferred genders"
        case .ageRange: "Your preferred age span"
        case .heightPreference: "Your preferred height"
        case .distancePreference: "Your preferred distance"
        case .smokingPreference: "Do you date smokers?"
        case .drinkingPreferences: "Do you date drinkers?"
        case .wantChilds: "Do you want childs?"
        case .sports: "Does your partner should do sports?"
        case .relationshipType: "Looking for"
        }
    }
    
    var firebaseFieldName: String {
        switch self {
        case .preferredGenders: "preferences.gender"
        case .ageRange: "preferences.agePreference"
        case .heightPreference: "preferences.height"
        case .distancePreference: "preferences.distance"
        case .smokingPreference: "preferences.smoking"
        case .drinkingPreferences: "preferences.drinking"
        case .wantChilds: "preferences.wantsChilds"
        case .sports: "preferences.sports"
        case .relationshipType: "preferences.relationshipType"
        }
    }
    
    var valueString: String? {
        switch self {
        case .preferredGenders(let genders):
            if let genders { return genders.map { $0.title}.seperated(emptyText: "No preferred genders") } else { return nil }
        case .ageRange(let agePreference):
            return agePreference?.rangeString
        case .heightPreference(let height):
            if let height { return String(height) } else { return nil }
        case .distancePreference(let distance):
            if let distance { return String(distance) } else { return nil }
        case .smokingPreference(let wantsSmokers):
            if let wantsSmokers { return wantsSmokers ? "Appreciated" : "Not appreciated" } else { return nil }
        case .drinkingPreferences(let wantsDrinkers):
            if let wantsDrinkers { return wantsDrinkers ? "Appreciated" : "Not appreciated" } else { return nil }
        case .wantChilds(let wantsChilds):
            if let wantsChilds { return wantsChilds ? "Yes" : "No" } else { return nil }
        case .sports(let wantsSport):
            if let wantsSport { return wantsSport ? "Yes" : "No" } else { return nil }
        case .relationshipType(let relationshipType):
            return relationshipType?.title
        }
    }
    
    var editText: String {
        switch self {
        case .preferredGenders: "Update what genders you prefer"
        case .ageRange: "Update your minimum and maximum desired age"
        case .heightPreference: "Update how tall your partners should be"
        case .distancePreference: "Update your maximum distance"
        case .smokingPreference: "Update if you accept smokers as partners"
        case .drinkingPreferences: "Update "
        case .wantChilds: "Update if you want childs"
        case .sports: "Update if your partner should do sports"
        case .relationshipType: "What kind of relation shit type fits you the most?"
        }
    }
    
    @ViewBuilder
    func editView(user: User) -> some View {
        switch self {
        case .preferredGenders(let genders):
            EditListView(
                items: Gender.allCases,
                initialSelected: genders == nil ? [] : genders!,
                title: editText,
                subTitle: nil,
                path: firebaseFieldName
            )
        
        case .ageRange(let agePreference):
            EditAgeRangeView(title: editText, agePreference: agePreference, path: firebaseFieldName)
            
        case .heightPreference(let height):
            EmptyView()
            
        case .distancePreference(let distance):
            EmptyView()
            
        case .smokingPreference(let bool):
            // MARK: TODO generische view für binäre optionen
            EmptyView()
            
        case .drinkingPreferences(let bool):
            EmptyView()
            
        case .wantChilds(let bool):
            EmptyView()
            
        case .sports(let bool):
            EmptyView()
            
        case .relationshipType(let relationshipType):
            EditListView(items: RelationshipType.allCases, title: editText, subTitle: title, path: firebaseFieldName)
        }
    }
}
