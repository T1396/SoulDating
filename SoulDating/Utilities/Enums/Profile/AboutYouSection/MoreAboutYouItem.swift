//
//  MoreAboutYouItem.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 04.07.24.
//

import Foundation
import SwiftUI

protocol AboutYouItemProtocol: Identifiable, CaseIterable {
    var title: String { get }
    var icon: String { get }
    func value(user: Binding<FireUser>) -> String?
    func editView(user: Binding<FireUser>) -> AnyView
}

extension MoreAboutYouItem: AboutYouItemProtocol {}

enum MoreAboutYouItem: String, Identifiable, CaseIterable {
    case interests, languages, fashionStyle, fitnessLevel

    var id: String { rawValue }

    var title: String {
        switch self {
        case .interests: "Your interests"
        case .languages: "Your spoken languages"
        case .fashionStyle: "Your fashion style"
        case .fitnessLevel: "How fit are you?"
        }
    }

    var firebaseFieldName: String {
        switch self {
        case .interests: "general.interests"
        case .languages: "general.languages"
        case .fashionStyle: "look.fashionStyle"
        case .fitnessLevel: "look.fitnessLevel"
        }
    }

    var icon: String {
        switch self {
        case .interests: "heart.circle.fill"
        case .languages: "globe"
        case .fashionStyle: "eyeglasses"
        case .fitnessLevel: "figure.stand.line.dotted.figure.stand"
        }
    }

    var updateText: String {
        switch self {
        case .interests: "Update your interests"
        case .languages: "Update what languages you speak"
        case .fashionStyle: "Update what kind of fashion you prefer"
        case .fitnessLevel: "Update your fitness level"
        }
    }

    func editView(user: Binding<FireUser>) -> AnyView {
        switch self {
        case .interests:
            AnyView(EditListView(
                items: Interest.allCases,
                initialSelected: user.general.interests,
                title: updateText,
                subTitle: nil,
                path: firebaseFieldName,
                allowsMultipleSelection: true
            ))

        case .languages:
            AnyView(EditLanguagesView(fieldName: firebaseFieldName, initialSelectedLanguages: user.wrappedValue.general.languages ?? []))

        case .fashionStyle:
            AnyView(EditListView(
                items: FashionStyle.allCases,
                initialSelected: user.look.fashionStyle,
                title: updateText,
                subTitle: nil,
                path: firebaseFieldName
            ))

        case .fitnessLevel:
            AnyView(EditListView(
                items: FitnessLevel.allCases,
                initialSelected: user.look.fitnessLevel,
                title: updateText,
                subTitle: nil,
                path: firebaseFieldName
            ))
        }

    }

    func value(user: Binding<FireUser>) -> String? {
        switch self {
        case .interests:
            let interests = user.general.interests.wrappedValue ?? []
            let value = interests.map { $0.title }.seperated(emptyText: "No interests provided")
            return value

        case .languages:
            let languages = user.general.languages.wrappedValue ?? []
            let value = languages.seperated(emptyText: "No languages selected")
            return value
            
        case .fashionStyle:
            return user.look.fashionStyle.wrappedValue?.title
        case .fitnessLevel:
            return user.look.fitnessLevel.wrappedValue?.title
        }
    }


}
