//
//  ProfileViewModel.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 21.06.24.
//

import Foundation

class ProfileViewModel: ObservableObject {
    private let firebaseManager = FirebaseManager.shared
    var aboutYouVm: AboutYouViewModel
    var prefVm: PreferencesViewModel
    @Published var user: User
    //var photosViewModel: PhotosViewModel
    
    init(user: User) {
        self.user = user
        aboutYouVm = AboutYouViewModel(user: user)
        prefVm = PreferencesViewModel(user: user)
    }
    
    func updateUserField<T: Codable>(_ fieldName: String, with value: T) {
        print(value)
        let db = firebaseManager.database
        print([fieldName: value])
        db.collection("users").document(user.id).updateData([fieldName: value]) { error in
            if let error = error {
                print("Error updating field \(fieldName): \(error.localizedDescription)")
            }
        }
    }
    
    func toDictionary<T: Encodable>(_ encodable: T) -> [String: Any]? {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(encodable)
            let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
            return dictionary
        } catch {
            print("Error converting Codable to dictionary: \(error)")
            return nil
        }
    }
    
    func updateUserField<T: Equatable>(_ path: WritableKeyPath<User, T>, with value: T) {
        if user[keyPath: path] != value {
            user[keyPath: path] = value
            updateSpecificUserField(path, with: value)
        }
    }
    
    func updateSpecificUserField<T: Equatable>(_ path: WritableKeyPath<User, T>, with value: T) {
        if user[keyPath: path] != value {
            user[keyPath: path] = value
            let fieldName = NSExpression(forKeyPath: path).keyPath  // ermittelt den Schlüsselpfad als String
            let db = firebaseManager.database
            db.collection("users").document(user.id).updateData([fieldName: value]) { error in
                if let error = error {
                    print("Error updating field: \(error.localizedDescription)")
                } else {
                    print("Field successfully updated")
                }
            }
        }
    }
}
