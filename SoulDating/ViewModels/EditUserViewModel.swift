//
//  EditUserViewModel.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 04.07.24.
//

import Foundation

class EditUserViewModel: BaseAlertViewModel {
    private let firebaseManager = FirebaseManager.shared
    private let userService: UserService

    init(userService: UserService = .shared) {
        self.userService = userService
    }

    func updateUserField<T: Codable>(_ fieldName: String, with value: T) {
        let db = firebaseManager.database
        db.collection("users").document(userService.user.id).updateData([fieldName: value]) { error in
            if let error = error {
                print("Error updating field \(fieldName): \(error.localizedDescription)")
                self.createAlert(title: "Update error", message: "We couldn't update your profile setting... Please report this as a bug or try again.")
            }
        }
    }

    func updateUserField(_ fieldName: String, with dict: [String: Any]) {
        let db = firebaseManager.database
        db.collection("users").document(userService.user.id).updateData([fieldName: dict]) { error in
            if let error {
                print("Error updating field \(fieldName)", error.localizedDescription)
                self.createAlert(title: "Update error", message: "We couldn't update your profile setting... Please report this as a bug or try again.")
            }
        }
    }
}
