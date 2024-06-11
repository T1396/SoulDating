//
//  UserViewModel.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 04.06.24.
//

import Foundation
import FirebaseAuth

class UserViewModel: ObservableObject {
    // MARK: properties
    private let firebaseManager = FirebaseManager.shared
    
    
    @Published var user: User? {
        didSet {
            if let user {
                onboardingCompleted = user.onboardingCompleted ?? false
            }
        }
    }
    @Published var mode: AuthMode = .login
    @Published var isAuthentificating = true
    @Published var onboardingCompleted = false
    @Published var email = ""
    @Published var password = ""
    @Published var passwordRepeat = ""

    
    // MARK: init
    init() {
        checkAuth()
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdate(_:)), name: .userDocumentUpdated, object: nil)
    }
    
    @objc
    private func didUpdate(_ notification: Notification) {
        fetchUser()
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
        user != nil
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
            self.user = nil
        } catch {
            print("Error signing out: ", error.localizedDescription)
        }
    }
}

// MARK: user document functions (crud)
extension UserViewModel {
    private func fetchUser() {
        guard let id = firebaseManager.userId else { return }
        print(id)
        firebaseManager.database.collection("users").document(id).getDocument { document, error in
            defer { self.isAuthentificating = false }
            if let error {
                print("Fehler beim fetchen", error.localizedDescription)
            }
            
            guard let document else {
                print("Dokument existiert nicht")
                return
            }
            
            do {
                self.user = try document.data(as: User.self)
            } catch {
                print("Error while decoding document into User Struct", error.localizedDescription)
            }
        }
    }
    
    func createUserDocument() {
        guard let userId = firebaseManager.userId else { return }
        let dict = ["id": userId]
        do {
            try firebaseManager.database.collection("users").document(userId).setData(from: dict)
            print("user successfully created")
        } catch {
            print("Fehler beim Speichern des Users", error)
        }
    }
    
    func updateProfileItem(_ item: ProfileItem) {
        switch item {
        case .name(let newName):
            self.user?.userName = newName
            updateUserDocumentField(field: "userName", value: newName)
        case .birthdate(let newDate):
            user?.birthDate = newDate
            updateUserDocumentField(field: "birthdate", value: newDate)
        case .location(let newLocation):
            user?.location = newLocation
            updateUserDocumentField(field: "location", value: newLocation)
        case .lookingFor(let newLookingFor):
            user?.preferredGender = newLookingFor
            updateUserDocumentField(field: "lookingFor", value: newLookingFor)
        case .interests(let newInterests):
            user?.interests = newInterests
            updateUserDocumentField(field: "interests", value: newInterests)
        }
    }
    
    private func updateUserDocumentField(field: String, value: Any) {
        let db = firebaseManager.database
        guard let userId = firebaseManager.userId else { return }
        db.collection("users").document(userId).updateData([field: value]) { error in
            if let error = error {
                print("Error updating Firestore: \(error)")
            } else {
                print("\(field) successfully updated in Firestore")
            }
        }
    }
}

// MARK: onboarding
extension UserViewModel {
    func updateOnboardingStatus(userId: String, completed: Bool) {
        firebaseManager.database.collection("users").document(userId).setData(["onboardingCompleted": completed], merge: true)
    }
    
    func completeOnboarding() {
        guard let userId = firebaseManager.userId else { return }
        updateOnboardingStatus(userId: userId, completed: true)
        self.onboardingCompleted = true
    }
}


