//
//  AboutYouItem.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 20.06.24.
//

import SwiftUI

enum AboutYouItem: Identifiable {
    /// general
    case name(String?)
    case birthDate(Date?)
    case gender(Gender?)
    case sex(Sexuality?)
    case location(LocationPreference?)
    case description(String?)
    /// look and lifestyle
    case height(Int?)
    case bodyType(BodyType?)
    case job(String?)
    case education(EducationLevel?)
    case alcohol(Bool?)
    /// interests
    case interests([Interest])
    case languages([String])
    case fashionStyle(FashionStyle?)
    case fitnessLevel(FitnessLevel?)
    
    
    var id: String {
        UUID().uuidString
    }
    
    var title: String {
        switch self {
            /// general
        case .name: "Name"
        case .birthDate: "Birthdate"
        case .gender: "Gender"
        case .sex: "Sexuality"
        case .location: "Your location"
        case .description: "Description about yourself"
            /// look and lifestyle
        case .height: "Your height"
        case .bodyType: "Your body type"
        case .job: "Your current job"
        case .education: "Your education level"
        case .alcohol: "Your alcohol behaviour"
            /// interests
        case .interests: "Your interests"
        case .languages: "Your spoken languages"
        case .fashionStyle: "What kind of fashion style do you meet"
        case .fitnessLevel: "How fit are you?"
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
        case .height: "look.height"
        case .bodyType: "look.bodyType"
        case .job: "general.job"
        case .education: "general.education"
        case .alcohol: "general.drinkingBehaviour"
        case .interests: "general.interests"
        case .languages: "general.languages"
        case .fashionStyle: "look.fashionStyle"
        case .fitnessLevel: "look.fitnessLevel"
        }
    }
    
    var icon: String {
        switch self {
            /// general
        case .name: "person.fill"
        case .birthDate: "calendar"
        case .gender: "person.2.fill"
        case .sex: "flame.fill"
        case .location: "map.fill"
        case .description: "text.quote"
            /// look and lifestyle
        case .height: "arrow.up.arrow.down"
        case .bodyType: "figure.walk"
        case .job: "briefcase.fill"
        case .education: "graduationcap.fill"
        case .alcohol: "cup.and.saucer.fill"
            /// interests
        case .interests: "heart.circle.fill"
        case .languages: "globe"
        case .fashionStyle: "eyeglasses"
        case .fitnessLevel: "figure.stand.line.dotted.figure.stand"
        }
    }
    
    var valueString: String? {
        switch self {
            /// general
        case .name(let name):
            return name
        case .birthDate(let date):
            return date?.toDateString()
        case .gender(let gender):
            return gender?.title
        case .sex(let sex):
            return sex?.title
        case .location(let locationPreference):
            return locationPreference != nil ? "\(String(describing: locationPreference?.name)), +\(String(describing: locationPreference?.radius)) km" : nil
        case .description(let description):
            return description
            ///  look and lifestyle
        case .height(let height):
            if let height { return String(height) } else { return nil }
        case .bodyType(let bodyType):
            return bodyType?.title
        case .job(let job):
            return job
        case .education(let educationLevel):
            return educationLevel?.title
        case .alcohol(let drinkingPreference):
            return drinkingPreference == nil ? "Not specified" : String(describing: drinkingPreference)
            /// interests
        case .interests(let interestList):
            return interestList.map { $0.title }.seperated(emptyText: "No languages")
        case .languages(let languages):
            return languages.seperated(emptyText: "No languages selected")
        case .fashionStyle(let fashionStyle):
            return fashionStyle?.title
        case .fitnessLevel(let fitnessLevel):
            return fitnessLevel?.title
        }
    }
    
    var updateText: String {
        switch self {
            /// general
        case .name: "Update your name"
        case .birthDate: "Update your date of birth"
        case .gender: "Update your current gender"
        case .sex: "Update your sex identity"
        case .location: "Updates your Location"
        case .description: "Update your description"
            /// look and lifestyle
        case .height: "Update your height"
        case .bodyType: "Update your body type"
        case .job: "Update your current job"
        case .education: "Update your level of education"
        case .alcohol: "Update your alcoholic behaviour"
            /// interests
        case .interests: "Update your interests"
        case .languages: "Update what languages you speak"
        case .fashionStyle: "Update what kind of fashion you prefer"
        case .fitnessLevel: "Update your fitness level"
        }
    }
    
    var supportText: String? {
        switch self {
            /// general
        case .name: nil
        case .birthDate: nil
        case .gender, .sex: "This will change how you are suggestes to others"
        case .location: "This will change your suggestions of users"
        case .description: "A good description can help you find more matches, write something special about you"
            /// look and lifestyle
        case .height: nil
        case .bodyType: nil
        case .job: nil
        case .education: nil
        case .alcohol: nil
            /// inerests
        case .interests: nil
        case .languages: nil
        case .fashionStyle: nil
        case .fitnessLevel: nil
        }
    }
    @ViewBuilder
    func editView(user: User) -> some View {
        switch self {
        // general
        case .name(let value), .job(let value):
            EditNameView(title: updateText, path: firebaseFieldName, text: value ?? "")
            
        case .birthDate(let date):
            EditDateView(title: updateText, date: date ?? Date().subtractYears(18), path: firebaseFieldName)
            
        case .gender(let gender):
            EditGenderView(title: updateText, supportText: supportText, initialGender: gender, path: firebaseFieldName)
            
        case .sex(let sexuality):
            EditListView(items: Sexuality.allCases, initialSelected: [sexuality ?? .hetero], title: updateText, subTitle: supportText, path: firebaseFieldName)
            
        case .location(let location):
            EditLocationRangeView(location: location, user: user)
            
        case .description(let newDescription):
            EditDescriptionView(title: updateText, initialDescription: newDescription ?? "", placeholder: "Enter a description about you.", path: firebaseFieldName)
            
        /// look and lifestyle
        case .height(let int):
            Text(String(describing: int))
            
        case .bodyType(let bodyType):
            EditListView(
                items: BodyType.allCases,
                initialSelected: bodyType == nil ? [] : [bodyType!],
                title: updateText,
                subTitle: supportText,
                path: firebaseFieldName
            )
            
        case .education(let educationLevel):
            EditListView(
                items: EducationLevel.allCases,
                initialSelected: educationLevel == nil ? [] : [educationLevel!],
                title: updateText,
                subTitle: supportText,
                path: firebaseFieldName
            )
            
        case .alcohol(let drinkingBehaviour):
            EmptyView()
            
        /// interests
        case .interests(let interests):
            EditListView(
                items: Interest.allCases,
                initialSelected: interests,
                title: updateText,
                subTitle: supportText,
                path: firebaseFieldName
            )
            
        case .languages(let array):
            Text(String(describing: array))
            
        case .fashionStyle(let fashionStyle):
            EditListView(
                items: FashionStyle.allCases,
                initialSelected: fashionStyle == nil ? [] : [fashionStyle!],
                title: updateText,
                subTitle: supportText,
                path: firebaseFieldName
            )
            
        case .fitnessLevel(let fitnessLevel):
            EditListView(
                items: FitnessLevel.allCases,
                initialSelected: fitnessLevel == nil ? []: [fitnessLevel!],
                title: updateText,
                subTitle: supportText,
                path: firebaseFieldName
            )
        }
    }
    //    @ViewBuilder
    //    func editView() -> some View {
    //        switch self {
    //            /// general
    //        case .name(let name):
    //            //
    //            EmptyView()
    //
    //        case .birthDate(let date):
    //            //
    //            EmptyView()
    //
    //        case .gender(let gender):
    //            //
    //            EmptyView()
    //        case .sex(let sex):
    //            // MARK: Edit Sex View
    ////            EditListView(items: Sexuality.allCases, title: updateText, subTitle: nil, path: firebaseFieldName)
    //            EmptyView()
    //
    //        case .location(let location):
    //            //
    //        case .description(let newDescription):
    //            // MARK: edit description view
    //            //
    //            EmptyView()
    //
    //            /// look and lifestyle
    //        case .height(let height):
    //            EmptyView()
    //        case .bodyType(let bodyType):
    ////
    //            EmptyView()
    //        case .job(let job):
    //            //
    //            EmptyView()
    //        case .education(let educationLevel):
    ////
    //            EmptyView()
    //        case .alcohol(let drinkingPreference):
    //            EmptyView()
    //            /// interests
    //        case .interests():
    ////
    //            EmptyView()
    //        case .languages(let languages):
    //            // MARK: TODO LANGUAGES JSON
    //            EmptyView()
    //        case .fashionStyle(let fashionStyle):
    ////
    //            EmptyView()
    //        case .fitnessLevel(let fitnessLevel):
    ////
    //            EmptyView()
    //        }
    //    }
}
