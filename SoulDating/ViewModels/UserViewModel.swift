//
//  UserViewModel.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 04.06.24.
//

import Foundation
import FirebaseAuth
import Firebase

class UserViewModel: ObservableObject {
    // MARK: properties
    private let firebaseManager = FirebaseManager.shared
    
    
    @Published var user: User
    @Published var mode: AuthentificationView = .login
    @Published var isAuthentificating = true
    @Published var onboardingCompleted = false
    @Published var email = ""
    @Published var password = ""
    @Published var passwordRepeat = ""
        
    var agePreferences: AgePreference? {
        user.preferences?.agePreferences
    }
    
    
    // MARK: init
    init() {
        user = User(id: "", registrationDate: .now)
        checkAuth()
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdate(_:)), name: .userDocumentUpdated, object: nil)
    }
    
    @objc
    private func didUpdate(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let updatedUser = userInfo["user"] as? User else { 
            print("Update user with notification failed")
            return
        }
        
        print("Updated with user notification successfully")
        self.user = updatedUser
    }
    
    // MARK: computed properties
    var disableAuth: Bool {
        email.isEmpty || password.isEmpty
    }
    
    var emailModeText: String {
        mode == .login ? "Mit E-Mail anmelden" : "Mit E-Mail registrieren"
    }
    
    var switchModeText: String {
        mode == .login ? "Noch kein Konto? Registrieren" : "Bereits registriert? Zum Login"
    }
    
    var userIsLoggedIn: Bool {
        firebaseManager.auth.currentUser != nil
    }
    
    var passwordMatches: Bool {
        passwordRepeat.count > 0 && passwordRepeat == password
    }
    
    // MARK: functions
    func switchAuthMode() {
        mode = mode == .login ? .register : .login
    }
}

// MARK: authentification functions
extension UserViewModel {
    private func checkAuth() {
        isAuthentificating = true
        guard firebaseManager.auth.currentUser != nil else {
            self.isAuthentificating = false
            print("Not logged in")
            return
        }
        self.fetchUser()
    }
    
    func signIn() {
        mode == .login ? login() : register()
    }
    
    private func login() {
        firebaseManager.auth.signIn(withEmail: email, password: password) { authResult, error in
            if let error {
                print("Login failed", error.localizedDescription)
            }
            
            guard let authResult, let email = authResult.user.email else { return }
            print("User (Email: \(email), id: \(authResult.user.uid)) is logged in")
            
            self.fetchUser()
        }
    }
    
    private func register() {
        firebaseManager.auth.createUser(withEmail: email, password: password) { authResult, error in
            if let error {
                print("Register failed", error.localizedDescription)
                return
            }
            
            guard let authResult, let email = authResult.user.email else { return }
            print("User (Email: \(email), id: \(authResult.user.uid)) registered himself")
            self.createUserDocument()
            self.fetchUser()
        }
    }
    
    func logout() {
        do {
            try firebaseManager.auth.signOut()
            print("signed out")
            isAuthentificating = false
            print(userIsLoggedIn)
        } catch {
            print("Error signing out: ", error.localizedDescription)
        }
    }
}

// MARK: user document functions (crud)
extension UserViewModel {
    private func fetchUser() {
        guard let id = firebaseManager.userId else { return }
        firebaseManager.database.collection("users").document(id).getDocument { document, error in
            if let error {
                print("Error while fetching user", error.localizedDescription)
            }
            
            guard let document else {
                print("user document doesnt exist")
                return
            }
            
            do {
                self.user = try document.data(as: User.self)
                self.onboardingCompleted = self.user.onboardingCompleted ?? false
                self.isAuthentificating = false
            } catch {
                print("Error while decoding document into User Struct", error.localizedDescription)
            }
        }
    }
    
    func createUserDocument() {
        guard let userId = firebaseManager.userId else { return }
        let user = User(id: userId, registrationDate: .now)
        do {
            try firebaseManager.database.collection("users").document(userId).setData(from: user)
            print("user successfully created")
        } catch {
            print("error saving user \(user)", error)
        }
    }
    
    func updateAgePreference(_ agePreference: AgePreference) {
        guard let userId = firebaseManager.userId else { return }
        firebaseManager.database.collection("users").document(userId)
            .updateData(["preferences.agePreferences": agePreference]) { error in
                if let error {
                    print("Error updating age preference")
                    return
                }
                
                self.user.preferences?.agePreferences = agePreference
            }
    }
}



