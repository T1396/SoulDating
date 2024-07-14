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
        case .relationshipType: Strings.relationshipTitle
        case .prefGenders: Strings.prefGenderTitle
        case .ageRange: Strings.prefAgeTitle
        case .heightPref: Strings.prefHeightTitle
        }
    }

    var supportText: String? {
        switch self {
        case .prefGenders, .ageRange: Strings.willUpdateSuggestions
        default: nil
        }
    }

    var editText: String {
        switch self {
        case .relationshipType: Strings.relationshipTitleEdit
        case .prefGenders: Strings.prefGenderTitleEdit
        case .ageRange: Strings.prefAgeTitle
        case .heightPref: Strings.prefHeightTitle
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
                String(height.formatted(as: .decimal, maxFractionDigits: 0, locale: .autoupdatingCurrent) ?? "No height provided") + "cm"
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
