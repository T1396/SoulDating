//
//  DatingPreferenceItem.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 04.07.24.
//

import Foundation
import SwiftUI

extension DatingPreferenceItem: AboutYouItemProtocol {}

enum DatingPreferenceItem: String, Identifiable, CaseIterable {
    case relationshipType, prefGenders, ageRange, heightPref

    var id: String { rawValue }

    var title: String {
        switch self {
        case .relationshipType: "Looking for"
        case .prefGenders: "Your preferred genders"
        case .ageRange: "Your preferred age span"
        case .heightPref: "Your preferred height"
        }
    }

    var supportText: String? {
        switch self {
        case .prefGenders, .ageRange: "This will change your suggestions you reveice."
        default: nil
        }
    }

    var editText: String {
        switch self {
        case .relationshipType: "What kind of relationship type fits you the most?"
        case .prefGenders: "Update what genders you prefer"
        case .ageRange: "Update your minimum and maximum desired age"
        case .heightPref: "Update how tall your partners should be at least"
        }
    }

    var firebaseFieldName: String {
        switch self {
        case .relationshipType: "preferences.relationshipType"
        case .prefGenders: "preferences.gender"
        case .ageRange: "preferences.agePreferences"
        case .heightPref: "preferences.height"
        }
    }

    var icon: String {
        switch self {
        case .relationshipType: "heart.circle"
        case .prefGenders: "person.2.fill"
        case .ageRange: "calendar"
        case .heightPref: "ruler"
        }
    }

    func value(user: Binding<FireUser>) -> String? {
        switch self {
        case .relationshipType:
            user.preferences.relationshipType.wrappedValue?.title
        case .prefGenders:
            user.preferences.gender.wrappedValue?.map { $0.title }.seperated(emptyText: "No preferred genders")
        case .ageRange:
            user.preferences.agePreferences.wrappedValue?.rangeString
        case .heightPref:
            if let height = user.preferences.height.wrappedValue {
                String(height)
            } else {
                nil
            }
        }
    }

    func editView(user: Binding<FireUser>) -> AnyView {
        switch self {
        case .relationshipType:
            AnyView(EditListView(
                items: RelationshipType.allCases,
                initialSelected: user.preferences.relationshipType,
                title: editText,
                subTitle: nil,
                path: firebaseFieldName,
                allowsMultipleSelection: false
            ))
        case .prefGenders:
            AnyView(EditListView(
                items: Gender.allCases,
                initialSelected: user.preferences.gender,
                title: editText,
                subTitle: nil,
                path: firebaseFieldName,
                allowsMultipleSelection: true
            ))
        case .ageRange:
            AnyView(EditAgeRangeView(
                title: editText,
                agePreference: user.preferences.agePreferences, path: firebaseFieldName))
        case .heightPref:
            AnyView(EditHeightView(title: editText, path: firebaseFieldName, initialValue: user.preferences.height, supportText: nil))
        }
    }
}
