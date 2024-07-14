//
//  UserService.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 06.07.24.
//

import Foundation

// singleton user service class to share the user with other ViewModels
class UserService: ObservableObject {
    static let shared = UserService()

    @Published var user: FireUser
    private var initialFetchedUser = false
    private let firebaseManager = FirebaseManager.shared

    private init() {
        self.user = FireUser(id: "-1")
    }

    func reset() {
        self.user = FireUser(id: "-1")
        self.initialFetchedUser = false
    }

    func fetchUserDocument(completion: @escaping () -> Void) {
        guard let userId = firebaseManager.userId else { return }
        firebaseManager.database.collection("users").document(userId)
            .getDocument { docSnapshot, error in
                if let error {
                    print("Failed to fetch userdocument in firestore", error.localizedDescription)
                    return
                }
                guard let docSnapshot else { return }
                do {
                    self.user = try docSnapshot.data(as: FireUser.self)
                    completion()
                } catch {
                    print("Error decoding document into user struct", error.localizedDescription)
                    completion()
                }
            }
    }

    func createUserDocument(completion: @escaping (Bool) -> Void) {
        guard let userId = firebaseManager.userId else { return }
        let user = FireUser(id: userId, registrationDate: .now)
        do {
            try firebaseManager.database.collection("users").document(userId).setData(from: user)
            print("user successfully created")
            completion(true)
        } catch {
            print("error saving user \(user)", error)
            completion(false)
        }
    }
}
