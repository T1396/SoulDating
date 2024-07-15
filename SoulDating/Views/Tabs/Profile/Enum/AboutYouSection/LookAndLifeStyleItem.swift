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
    case height, bodyType, job, education, drinkingBehaviour, smokingStatus

    var id: String { rawValue }

    var title: String {
        switch self {
        case .height: Strings.yourHeight
        case .bodyType: Strings.yourBodyType
        case .job: Strings.yourJob
        case .education: Strings.yourEducation
        case .drinkingBehaviour: Strings.yourDrinkingBehaviour
        case .smokingStatus: Strings.yourSmokingBehaviour
        }
    }

    var firebaseFieldName: String {
        switch self {
        case .height: "look.height"
        case .bodyType: "look.bodyType"
        case .job: "general.job"
        case .education: "general.education"
        case .drinkingBehaviour: "general.drinkingBehaviour"
        case .smokingStatus: "general.smokingStatus"
        }
    }

    var icon: String {
        switch self {
        case .height: "pencil.and.ruler.fill"
        case .bodyType: "figure.walk"
        case .job: "briefcase.fill"
        case .education: "graduationcap.fill"
        case .drinkingBehaviour: "waterbottle.fill"
        case .smokingStatus: "lungs.fill"
        }
    }

    var updateText: String {
        switch self {
        case .height: Strings.updateYourHeight
        case .bodyType: Strings.updateBodyType
        case .job: Strings.updateJob
        case .education: Strings.updateEducation
        case .drinkingBehaviour: Strings.updateDrinking
        case .smokingStatus: Strings.updateSmoking
        }
    }

    var placeholder: String {
        switch self {
        case .job: Strings.jobPlaceholder
        default: ""
        }
    }

    var errorMessage: String? {
        switch self {
        case .job: Strings.atleast3Chars
        default: nil
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
            AnyView(EditTextFieldView(
                title: updateText,
                path: firebaseFieldName,
                initialText: user.general.job,
                placeholder: placeholder,
                errorMessage: errorMessage,
                supportText: nil
            ))

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

        case .smokingStatus:
            AnyView(EditListView(
                items: SmokeLevel.allCases,
                initialSelected: user.general.smokingStatus,
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
                return String(height.formatted(as: .decimal, maxFractionDigits: 0, locale: .autoupdatingCurrent) ?? "No height provided") + "cm"
            }
            return nil

        case .bodyType:
            return user.wrappedValue.look.bodyType.title

        case .job:
            return user.wrappedValue.general.job
        case .education:
            return user.wrappedValue.general.education.title
        case .drinkingBehaviour:
            return user.wrappedValue.general.drinkingBehaviour?.title
        case .smokingStatus:
            return user.wrappedValue.general.smokingStatus.title
        }
    }
}
