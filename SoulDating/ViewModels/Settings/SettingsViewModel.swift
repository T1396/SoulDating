//
//  SettingsViewModel.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 05.07.24.
//

import Foundation
import Firebase
/// ViewModel for Account Settings in the SettingsView to update email and password and to delete user account
class SettingsViewModel: BaseAlertViewModel {
    // MARK: properties
    enum State { case input, loading, success }
    private let firebaseManager = FirebaseManager.shared
    private let userService: UserService

    @Published var state: State = .input
    @Published var newMail = ""
    @Published var password = ""
    @Published var passwordRepeat = ""
    @Published var newPassword = ""

    @Published var passwordError: String?
    @Published var emailChangeFailed = true
    @Published var passwordChangeFailed = true

    // MARK: computed properties

    var email: String {
        firebaseManager.auth.currentUser?.email ?? ""
    }

    init(userService: UserService = .shared) {
        self.userService = userService
    }

    var updatePasswordDisabled: Bool {
        password.count < 6 || passwordRepeat.count < 6 || newPassword.count < 6 ||
        newPassword == password
    }

    var emailChangeDisabled: Bool {
        newMail.count < 6 || password.count < 6
    }

    // MARK: functions
    private func resetValues() {
        newMail = ""
        password = ""
    }

    private func resetPasswords() {
        password = ""
        passwordRepeat = ""
        newPassword = ""
    }

    /// must be called before changing email or password
    func reauthentificateUser(email: String, password: String, completion: @escaping (Bool) -> Void) {
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        firebaseManager.auth.currentUser?.reauthenticate(with: credential) { _, error in
            if let error {
                print("Failed to re-authentificate", error.localizedDescription)
                self.createAlert(title: "Error", message: "Failed to authorize. Check your password or email")
                completion(false)
                return
            }
            completion(true)
            print("reauth successfully")
        }
    }
}

// MARK: CHANGE PASSWORD
extension SettingsViewModel {
    func changePassword() {
        state = .loading
        reauthentificateUser(email: email, password: password) { success in
            if success {
                self.firebaseManager.auth
                    .currentUser?.updatePassword(to: self.newPassword, completion: { error in
                        if let error {
                            print("Error while updating password", error.localizedDescription)
                            self.createAlert(title: "Error", message: "An error occured while updating your password, try again or report a bug.")
                            return
                        }
                        self.executeDelayed {
                            self.state = .success
                            self.resetPasswords()
                        }

                        print("Password successfully updated")
                    })
            } else {
                self.state = .input
            }
        }

    }
}

// MARK: CHANGE EMAIL
extension SettingsViewModel {
    func attemptChangeMail() {
        createAlert(title: "Attention", message: "You will be signed out if you update your e-mail. You will receive an link to update your email address. If you don't want to change the email, just login again.", onAccept: changeMail)
    }

    func changeMail() {
        guard let user = firebaseManager.auth.currentUser else { return }
        state = .loading
        reauthentificateUser(email: email, password: password) { success in
            if success {
                user.sendEmailVerification(beforeUpdatingEmail: self.newMail) { error in
                    if let error {
                        print("Error changing email", error.localizedDescription)
                        self.createAlert(title: "Error", message: "The verification mail could not be send. Try again or report this as a bug.")
                        return
                    }
                    self.executeDelayed {
                        self.state = .success
                    }
                    do {
                        try self.firebaseManager.auth.signOut()
                        self.userService.reset()
                    } catch {
                        print("Error signing out", error.localizedDescription)
                    }
                    print("Verification Mail send. Check your mailbox.")
                    self.resetValues()
                }
            } else {
                self.state = .input
            }
        }
    }
}

// MARK: DELETE ACCOUNT FUNCTIONS
extension SettingsViewModel {
    /// creates an alert with a closure to 'deleteAccount' function  that gets called when the allert is accepted
    func attemptDeleteAccount() {
        createAlert(title: "Attention", message: "Do you really want to delete your account and all stored chats and images you made? This cannot be undone!", onAccept: deleteAccount)
    }

    /// deletes the user data from every relevant collection, chats /messages will be untouched
    private func deleteAccount() {
        guard let userId = firebaseManager.userId else { return }
        let db = firebaseManager.database
        let batch = db.batch()

        let collections = [
            "users",
            "userLikes",
            "userImages",
            "userActions",
            "userReports",
            "gptConversations"
        ]

        for collection in collections {
            let docRef = db.collection(collection).document(userId)
            batch.deleteDocument(docRef)
        }

        batch.commit { [weak self] error in
            if let error {
                print("Error deleting account", error.localizedDescription)
                return
            }
            // delete images from storage if all userdata were successfully deleted
            self?.deleteImageFromStorage(userId: userId)

            self?.firebaseManager.auth.currentUser?.delete(completion: { error in
                if let error {
                    print("Failed to delete auth user from firebase", error.localizedDescription)
                    return
                }

                print("User auth successfully deleted")
                self?.userService.reset()
                self?.createAlert(title: "Success", message: "Your account has been successfully deleted.")
            })
        }
    }

    /// deletes any images a user uploaded to the storage
    private func deleteImageFromStorage(userId: String) {
        let storageRef = firebaseManager.storage.reference().child("profileImages/\(userId)")
        // get all files in the reference for the user and delete them
        storageRef.listAll { result, error in
            if let error {
                print("Failed to find files while deleting user images", error.localizedDescription)
                return
            }
            guard let items = result?.items else {
                print("No images found")
                return
            }

            for item in items {
                item.delete { error in
                    if let error {
                        print("Error deleting image", error.localizedDescription)
                    }
                }
            }
        }
    }
}
