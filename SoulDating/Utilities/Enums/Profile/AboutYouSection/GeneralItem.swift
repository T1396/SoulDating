//
//  GeneralItem.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 04.07.24.
//

import SwiftUI
import Foundation

extension GeneralItem: AboutYouItemProtocol {}

enum GeneralItem: String, Identifiable, CaseIterable {
    case name, birthDate, gender, sex, location, description

    var id: String { rawValue }

    var title: String {
        switch self {
        case .name: "Name"
        case .birthDate: "Birthdate"
        case .gender: "Gender"
        case .sex: "Sexuality"
        case .location: "Your location"
        case .description: "Description about yourself"
        }
    }

    var firebaseFieldName: String {
        switch self {
        case .name: "name"
        case .birthDate: "birthdate"
        case .gender: "gender"
        case .sex: "general.sexuality"
        case .location: "location"
        case .description: "general.description"
        }
    }

    var icon: String {
        switch self {
        case .name: "person.crop.square.fill"
        case .birthDate: "calendar"
        case .gender: "person.2.fill"
        case .sex: "flame.fill"
        case .location: "map.fill"
        case .description: "text.quote"
        }
    }

    func value(user: Binding<FireUser>) -> String? {
        switch self {
        case .name:
            user.wrappedValue.name
        case .birthDate:
            user.wrappedValue.birthDate?.toDateString()
        case .gender:
            user.wrappedValue.gender?.title
        case .sex:
            user.wrappedValue.general.sexuality?.title
        case .location:
            user.wrappedValue.location.name
        case .description:
            user.wrappedValue.general.description
        }
    }

    var updateText: String {
        switch self {
        case .name: "Update your name"
        case .birthDate: "Update your date of birth"
        case .gender: "Update your current gender"
        case .sex: "Update your sex identity"
        case .location: "Updates your Location"
        case .description: "Update your description"
        }
    }

    var placeholderText: String {
        switch self {
        case .name: "Enter your name"
        case .description: "Enter a description about you"
        default: ""
        }
    }


    var supportText: String? {
        switch self {
        case .gender, .sex: "This will change how you are suggested to others"
        case .location: "This will change your suggestions of users"
        case .description: "A good description can help you find more matches, write something special about you"
        default: nil
        }
    }

    var errorText: String {
        switch self {
        case .name: "Your name must contain at least 3 Characters"
        case .description: "Your description should be at least 10 characters long..."
        default: ""
        }
    }



     func editView(user: Binding<FireUser>) -> AnyView {
         switch self {
         case .name:
             AnyView(EditTextFieldView(
                title: updateText,
                path: firebaseFieldName,
                initialText: user.name,
                placeholder: placeholderText,
                errorMessage: errorText,
                supportText: supportText
            ))

         case .birthDate:
             AnyView(EditDateView(title: updateText, date: user.birthDate, path: firebaseFieldName))

         case .gender:
             AnyView(EditGenderView(title: updateText, supportText: supportText, initialGender: user.gender, path: firebaseFieldName))

         case .sex:
             AnyView(EditListView(
                items: Sexuality.allCases,
                initialSelected: user.general.sexuality,
                title: updateText,
                subTitle: supportText,
                path: firebaseFieldName,
                allowsMultipleSelection: false
            ))

         case .location:
             AnyView(EditLocationRangeView())
         case .description:
             AnyView(EditDescriptionView(title: updateText, initialDescription: user.general.description, placeholder: "Enter a description about you.", path: firebaseFieldName))

         }
     }


}
