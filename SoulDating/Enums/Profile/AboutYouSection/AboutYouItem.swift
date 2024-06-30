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
    case location(LocationPreference)
    case description(String?)
    /// look and lifestyle
    case height(Double?)
    case bodyType(BodyType?)
    case job(String?)
    case education(EducationLevel?)
    case drinkingBehaviour(DrinkingBehaviour?)
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
        case .drinkingBehaviour: "Your alcohol behaviour"
            /// interests
        case .interests: "Your interests"
        case .languages: "Your spoken languages"
        case .fashionStyle: "Your fashion style"
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
        case .drinkingBehaviour: "general.drinkingBehaviour"
        case .interests: "general.interests"
        case .languages: "general.languages"
        case .fashionStyle: "look.fashionStyle"
        case .fitnessLevel: "look.fitnessLevel"
        }
    }
    
    var icon: String {
        switch self {
            /// general
        case .name: "person.crop.square.fill"
        case .birthDate: "calendar"
        case .gender: "person.2.fill"
        case .sex: "flame.fill"
        case .location: "map.fill"
        case .description: "text.quote"
            /// look and lifestyle
        case .height: "pencil.and.ruler.fill"
        case .bodyType: "figure.walk"
        case .job: "briefcase.fill"
        case .education: "graduationcap.fill"
        case .drinkingBehaviour: "waterbottle.fill"
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
            return "\(locationPreference.name), +\(locationPreference.radius) km"
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
        case .drinkingBehaviour(let drinkingPreference):
            return drinkingPreference == nil ? "Not specified" : String(drinkingPreference!.title)
            /// interests
        case .interests(let interestList):
            return interestList.map { $0.title }.seperated(emptyText: "No interests")
        case .languages(let languages):
            return languages.seperated(emptyText: "No languages selected")
        case .fashionStyle(let fashionStyle):
            return fashionStyle?.title
        case .fitnessLevel(let fitnessLevel):
            return fitnessLevel?.title
        }
    }
    
    var errorText: String {
        switch self {
        case .name: "Your name must contain at least 3 Characters"
        case .job: "Your job must contain at least 4 characters"
        case .description: "Your description should be at least 10 characters long..."
        default: ""
        }
    }
    
    var placeholderText: String {
        switch self {
        case .name: "Enter your name"
        case .job: "Enter your job"
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
        case .drinkingBehaviour: "Update your alcoholic behaviour"
            /// interests
        case .interests: "Update your interests"
        case .languages: "Update what languages you speak"
        case .fashionStyle: "Update what kind of fashion you prefer"
        case .fitnessLevel: "Update your fitness level"
        }
    }
    
    @ViewBuilder
    func editView(user: User) -> some View {
        switch self {
        // general
        case .name(let value), .job(let value):
            EditTextFieldView(
                title: updateText,
                path: firebaseFieldName,
                text: value ?? "",
                placeholder: placeholderText,
                errorMessage: errorText,
                supportText: supportText
            )
            
        case .birthDate(let date):
            EditDateView(title: updateText, date: date ?? Date().subtractYears(18), path: firebaseFieldName)
            
        case .gender(let gender):
            EditGenderView(title: updateText, supportText: supportText, initialGender: gender, path: firebaseFieldName)
            
        case .sex(let sexuality):
            EditListView(
                items: Sexuality.allCases,
                initialSelected: sexuality == nil ? [] : [sexuality!],
                title: updateText,
                subTitle: supportText,
                path: firebaseFieldName,
                allowsMultipleSelection: false
            )
            
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
            
        case .drinkingBehaviour(let drinkingBehaviour):
            EditListView(
                items: DrinkingBehaviour.allCases,
                initialSelected: drinkingBehaviour == nil ? [] : [drinkingBehaviour!],
                title: updateText,
                subTitle: supportText,
                path: firebaseFieldName
            )
            EmptyView()
            
        /// interests
        case .interests(let interests):
            EditListView(
                items: Interest.allCases,
                initialSelected: interests,
                title: updateText,
                subTitle: supportText,
                path: firebaseFieldName,
                allowsMultipleSelection: true
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

}
