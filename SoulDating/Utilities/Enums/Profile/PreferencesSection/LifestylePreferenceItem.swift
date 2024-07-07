//
//  LifestylePreferenceItem.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 04.07.24.
//

import Foundation
import SwiftUI

extension LifestylePreferenceItem: AboutYouItemProtocol {}

enum LifestylePreferenceItem: String, Identifiable, CaseIterable {
    case smokingPref, drinkingPref, childPref, sportPref

    var id: String { rawValue }

    var title: String {
        switch self {
        case .smokingPref: "Do you date smokers?"
        case .drinkingPref: "Do you date drinkers?"
        case .childPref: "Do you want childs?"
        case .sportPref: "Do you want a sportsman?"
        }
    }

    var icon: String {
        switch self {
        case .smokingPref: "smoke.fill"
        case .drinkingPref: "cup.and.saucer.fill"
        case .childPref: "poweroutlet.type.k.fill"
        case .sportPref: "sportscourt.fill"
        }
    }

    var firebaseFieldName: String {
        switch self {
        case .smokingPref: "preferences.smoking"
        case .sportPref: "preferences.sports"
        case .drinkingPref: "preferences.drinking"
        case .childPref: "preferences.wantsChilds"
        }
    }

    var editText: String {
        switch self {
        case .smokingPref: "Do you accept smoker?"
        case .drinkingPref: "Do you accept drinkers?"
        case .childPref: "Do you want childs"
        case .sportPref: "Should your partner do sports?"
        }
    }

    func value(user: Binding<FireUser>) -> String? {
        switch self {
        case .smokingPref:
            if let smokingPref = user.preferences.smoking.wrappedValue {
                return smokingPref ? "Appreciated" : "Not appreciated"
            } else {
                return nil
            }
        case .drinkingPref:
            if let drinkingPref = user.preferences.drinking.wrappedValue {
                return drinkingPref ? "Appreciated" : "Not appreciated"
            } else {
                return nil
            }
        case .childPref:
            if let childPref = user.preferences.wantsChilds.wrappedValue {
                return childPref ? "Yes" : "No"
            } else {
                return nil
            }
        case .sportPref:
            if let sportPref = user.preferences.sports.wrappedValue {
                return sportPref ? "Yes" : "No"
            } else {
                return nil
            }
        }
    }

    func editView(user: Binding<FireUser>) -> AnyView {
        switch self {
        case .smokingPref:
            AnyView(EditBoolView(
                title: editText,
                subtitle: nil,
                isEnabled: user.preferences.smoking,
                fieldName: firebaseFieldName
            ))
        case .drinkingPref:
            AnyView(EditBoolView(
                title: editText,
                subtitle: nil,
                isEnabled: user.preferences.drinking,
                fieldName: firebaseFieldName
            ))
        case .childPref:
            AnyView(EditBoolView(
                title: editText,
                subtitle: nil,
                isEnabled: user.preferences.wantsChilds,
                fieldName: firebaseFieldName
            ))
        case .sportPref:
            AnyView(EditBoolView(
                title: editText,
                subtitle: nil,
                isEnabled: user.preferences.sports,
                fieldName: firebaseFieldName
            ))
        }
    }
}
