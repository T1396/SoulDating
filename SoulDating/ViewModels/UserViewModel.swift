//
//  UserViewModel.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 04.06.24.
//

import Foundation
import FirebaseAuth
import Firebase

class UserViewModel: ObservableObject, RangeCalculating {
    internal let rangeManager: RangeManager = .init()
    
    func distance(to targetLocation: LocationPreference) -> String? {
        return rangeManager.distanceString(from: user.location, to: targetLocation)
    }
    
    // MARK: properties
    private let firebaseManager = FirebaseManager.shared
    
    
    @Published var user: User
    @Published var mode: AuthentificationMode = .login
    @Published var isAuthentificating = true
    @Published var onboardingCompleted = false
    @Published var email = ""
    @Published var password = ""
    @Published var passwordRepeat = ""
        
    var agePreferences: AgePreference? {
        user.preferences.agePreferences
    }
    
    
    // MARK: init
    init() {
        user = User(id: "", registrationDate: .now)
        checkAuth()
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
        self.setUserListener()
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
            
            self.setUserListener()
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
            self.setUserListener()
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
    
    private func setUserListener() {
        guard let userId = firebaseManager.userId else { return }
        firebaseManager.database.collection("users").document(userId)
            .addSnapshotListener { snapshot, error in
                if let error {
                    print("Failed to listen to user in firestore", error.localizedDescription)
                    return
                }
                guard let snapshot else { return }
                do {
                    self.user = try snapshot.data(as: User.self)
                    NotificationCenter.default.post(name: .userDocumentUpdated, object: nil, userInfo: ["user": self.user])
                    self.onboardingCompleted = self.user.onboardingCompleted ?? false
                    self.isAuthentificating = false
                } catch {
                    print("Error decoding document into user struct", error.localizedDescription)
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
                    print("Error updating age preference", error.localizedDescription)
                    return
                }
                
                self.user.preferences.agePreferences = agePreference
            }
    }
}



