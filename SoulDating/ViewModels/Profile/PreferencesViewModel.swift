//
//  PreferencesViewModel.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 20.06.24.
//

import Foundation

class PreferencesViewModel: ObservableObject {
    private let firebaseManager = FirebaseManager.shared
    var user: User
    
    init(user: User) {
        self.user = user
    }
    
    func updatePreferencesSetting(_ setting: PreferencesItem) {
        var firebaseFieldName = setting.firebaseFieldName
        var updatedItem: Any? = nil
        updatedItem = switch setting {
        case .preferredGenders(let genders): genders
        case .ageRange(let agePreference): agePreference
        case .heightPreference(let height): height
        case .distancePreference(let distance): distance
        case .smokingPreference(let bool): bool
        case .drinkingPreferences(let wantsDrinkers): wantsDrinkers
        case .wantChilds(let wantsChilds): wantsChilds
        case .sports(let wantsSport): wantsSport
        case .relationshipType(let relationshipType): relationshipType
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

