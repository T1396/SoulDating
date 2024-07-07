//
//  LookAndLifeStyleItem.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 04.07.24.
//

import Foundation
import SwiftUI


extension LookAndLifeStyleItem: AboutYouItemProtocol {}

enum LookAndLifeStyleItem: String, Identifiable, CaseIterable {
    case height, bodyType, job, education, drinkingBehaviour

    var id: String { rawValue }

    var title: String {
        switch self {
        case .height: "Your height"
        case .bodyType: "Your body type"
        case .job: "Your current job"
        case .education: "Your education level"
        case .drinkingBehaviour: "Your alcohol behaviour"
        }
    }

    var firebaseFieldName: String {
        switch self {
        case .height: "look.height"
        case .bodyType: "look.bodyType"
        case .job: "general.job"
        case .education: "general.education"
        case .drinkingBehaviour: "general.drinkingBehaviour"
        }
    }

    var icon: String {
        switch self {
        case .height: "pencil.and.ruler.fill"
        case .bodyType: "figure.walk"
        case .job: "briefcase.fill"
        case .education: "graduationcap.fill"
        case .drinkingBehaviour: "waterbottle.fill"
        }
    }

    var updateText: String {
        switch self {
        case .height: "Update your height"
        case .bodyType: "Update your body type"
        case .job: "Update your current job"
        case .education: "Update your level of education"
        case .drinkingBehaviour: "Update your alcoholic behaviour"
        }
    }

   
    func editView(user: Binding<FireUser>) -> AnyView {
        switch self {
        case .height:
            AnyView(EditHeightView(title: updateText, path: firebaseFieldName, initialValue: user.look.height, supportText: nil))

        case .bodyType:
            AnyView(EditListView(
                items: BodyType.allCases,
                initialSelected: user.look.bodyType,
                title: updateText,
                subTitle: nil,
                path: firebaseFieldName
            ))

        case .job:
            AnyView(EmptyView())

        case .education:
            AnyView(EditListView(
                items: EducationLevel.allCases,
                initialSelected: user.general.education,
                title: updateText,
                subTitle: nil,
                path: firebaseFieldName
            ))

        case .drinkingBehaviour:
            AnyView(EditListView(
                items: DrinkingBehaviour.allCases,
                initialSelected: user.general.drinkingBehaviour,
                title: updateText,
                subTitle: nil,
                path: firebaseFieldName
            ))

        }
    }

    func value(user: Binding<FireUser>) -> String? {
        switch self {
        case .height:
            if let height = user.wrappedValue.look.height {
                return String(height)
            }
            return nil

        case .bodyType:
            return user.wrappedValue.look.bodyType?.title

        case .job:
            return user.wrappedValue.general.job
        case .education:
            return user.wrappedValue.general.education?.title
        case .drinkingBehaviour:
            return user.wrappedValue.general.drinkingBehaviour?.title
        }
    }
}
