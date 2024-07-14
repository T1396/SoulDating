//
//  EditUserViewModel.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 04.07.24.
//

import Foundation

/// ViewModel to update specific user attributes, is used in each Edit Element for User Attributes
/// which can be found in Tabs/Profile/Edit
class EditUserViewModel: BaseAlertViewModel {
    private let firebaseManager = FirebaseManager.shared
    private let userService: UserService

    init(userService: UserService = .shared) {
        self.userService = userService
    }
    
    /// accepts a fieldName to update this field in firestore with the inserted generic value
    func updateUserField<T: Codable>(_ fieldName: String, with value: T) {
        let db = firebaseManager.database
        db.collection("users").document(userService.user.id).updateData([fieldName: value]) { error in
            if let error = error {
                print("Error updating field \(fieldName): \(error.localizedDescription)")
                self.createUpdateErrorAlert()
            }
        }
    }
    
    /// accepts a fieldName to update this field in firestore with the inserted dictionary
    func updateUserField(_ fieldName: String, with dict: [String: Any]) {
        let db = firebaseManager.database
        db.collection("users").document(userService.user.id).updateData([fieldName: dict]) { error in
            if let error {
                print("Error updating field \(fieldName)", error.localizedDescription)
                self.createUpdateErrorAlert()
            }
        }
    }

    private func createUpdateErrorAlert() {
        createAlert(title: Strings.error, message: Strings.updateUserError)
    }
}
