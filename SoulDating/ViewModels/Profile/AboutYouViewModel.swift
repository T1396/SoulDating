//
//  EditUserViewModel.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 17.06.24.
//

import Foundation

class AboutYouViewModel: ObservableObject {
    private let firebaseManager = FirebaseManager.shared
    var user: User
    
    init(user: User) {
        self.user = user
    }
    
    func updateAboutYouSetting(_ setting: AboutYouItem) {
        var firebaseFieldName = setting.firebaseFieldName
        var updatedItem: Any? = nil
        updatedItem = switch setting {
        case .name(let name): name
        case .birthDate(let date): date
        case .gender(let gender): gender
        case .sex(let sexuality): sexuality
        case .location(let locationPreference): locationPreference
        case .description(let description): description
        case .height(let newHeight): newHeight
        case .bodyType(let bodyType): bodyType
        case .job(let newJob): newJob
        case .education(let newEducationLevel): newEducationLevel
        case .alcohol(let newDrinkingBehaviour): newDrinkingBehaviour
        case .interests(let newInterests): newInterests
        case .languages(let newLanguages): newLanguages
        case .fashionStyle(let newFashionStyle): newFashionStyle
        case .fitnessLevel(let newFitnessLevel): newFitnessLevel
        }
        updateUserDocumentField(field: firebaseFieldName, value: updatedItem as Any)
    }
    
    
    private func updateUserDocumentField(field: String, value: Any) {
        let db = firebaseManager.database
        guard let userId = firebaseManager.userId else { return }
        db.collection("users").document(userId).updateData([field: value]) { error in
            if let error = error {
                print("Error updating Firestore: \(error)")
            } else {
                print("\(field) successfully updated in Firestore")
                NotificationCenter.default.post(name: .userDocumentUpdated, object: nil, userInfo: ["user": self.user])
            }
        }
    }
}
