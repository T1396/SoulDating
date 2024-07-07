//
//  UserViewModel.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 04.06.24.
//

import Foundation
import FirebaseAuth
import Firebase
import Combine

class UserViewModel: BaseAlertViewModel {
    // MARK: properties
    private var cancellables = Set<AnyCancellable>()
    private let firebaseManager = FirebaseManager.shared
    private let userService: UserService
    private let rangeManager = RangeManager()

    @Published var user: FireUser {
        didSet {
            if !onboardingCompleted {
                onboardingCompleted = user.onboardingCompleted ?? false
            }
        }
    }
    @Published var mode: AuthentificationMode = .login
    @Published var isAuthentificating = true
    @Published var onboardingCompleted = false
    @Published var email = ""
    @Published var password = ""
    @Published var passwordRepeat = ""




    // MARK: init
    init(userService: UserService = .shared) {
        self.userService = userService
        self.user = userService.user
        super.init()
        userService.$user
            .compactMap { $0 }
            .sink { [weak self] user in
                print("SINKED USER FORM SERVICE")
                self?.user = user
            }
            .store(in: &cancellables)
        checkAuth()
    }

    // MARK: computed properties
    var agePreferences: AgePreference? {
        userService.user.preferences.agePreferences
    }

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
        !passwordRepeat.isEmpty && passwordRepeat == password
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
            return
        }
        
        fetchUserDoc()
    }

    

    private func fetchUserDoc() {
        userService.fetchUserDocument {
            self.onboardingCompleted = self.userService.user.onboardingCompleted ?? false
            self.isAuthentificating = false
        }
    }

    private func login() {
        firebaseManager.auth.signIn(withEmail: email, password: password) { _, error in
            if let error {
                print("Login failed", error.localizedDescription)
                return
            }
            self.fetchUserDoc()
        }
    }

    func attemptLogout() {
        self.createAlert(title: "Sign out", message: "Do you really want to logout?", onAccept: logout)
    }

    func logout() {
        do {
            try firebaseManager.auth.signOut()
            isAuthentificating = false
            userService.reset()
        } catch {
            print("Error signing out: ", error.localizedDescription)
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
            self.userService.createUserDocument { _ in
                self.isAuthentificating = false
                self.onboardingCompleted = false
            }
        }
    }

    func signIn() {
        switch mode {
        case .login: login()
        case .register: register()
        }
    }
}
