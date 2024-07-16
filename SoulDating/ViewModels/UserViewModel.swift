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

/// ViewModel to handle authentification and holds a reference to the chatService to show notifications
class UserViewModel: BaseAlertViewModel {
    // MARK: properties

    private(set) lazy var chatService: ChatService = {
        let service = ChatService.shared
        return service
    }()

    private (set) lazy var likesService: LikesService = {
        let service = LikesService.shared
        return service
    }()

    private var cancellables = Set<AnyCancellable>()
    private let firebaseManager = FirebaseManager.shared
    private let userService: UserService
    private let rangeManager = RangeManager.shared

    @Published var mode: AuthentificationMode = .login
    @Published var isAuthentificating = true
    @Published var onboardingCompleted = false
    @Published var email = ""
    @Published var password = ""
    @Published var passwordRepeat = ""

    @Published private (set) var userIsLoggedIn: Bool = false {
        didSet {
            if userIsLoggedIn {
                // initialize the chatservice/likesService once user is logged in
                _ = chatService
                _ = likesService
            }
        }
    }


    // MARK: init
    init(userService: UserService = .shared) {
        self.userService = userService
        super.init()
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

    var passwordMatches: Bool {
        !passwordRepeat.isEmpty && passwordRepeat == password
    }

    // MARK: functions
    func switchAuthMode() {
        mode = mode == .login ? .register : .login
    }

    func updateOnboardingStatus() {
        onboardingCompleted = true
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
        self.userIsLoggedIn = true
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
            self.resetTextValues()
            if let error {
                print("Login failed", error.localizedDescription)
                self.createAlert(title: "Error", message: "Login failed: \(error.localizedDescription)")
                return
            }
            self.userIsLoggedIn = true
            self.fetchUserDoc()
        }
    }

    func attemptLogout() {
        self.createAlert(title: "Sign out", message: "Do you really want to logout?", onAccept: logout)
    }

    func logout() {
        do {
            try firebaseManager.auth.signOut()
            firebaseManager.database.clearPersistence()
            isAuthentificating = false
            userService.reset()
            chatService.reset()
            self.userIsLoggedIn = false
        } catch {
            print("Error signing out: ", error.localizedDescription)
        }
    }

    private func register() {
        firebaseManager.auth.createUser(withEmail: email, password: password) { _, error in
            self.resetTextValues()
            if let error {
                print("Register failed", error.localizedDescription)
                self.createAlert(title: Strings.error, message: String(format: Strings.registrationFailed, error.localizedDescription))
                return
            }
            
            self.userIsLoggedIn = true
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

    func resetTextValues() {
        email = ""
        password = ""
        passwordRepeat = ""
    }
}

// MARK: delete account when error occured to retry create account
extension UserViewModel {
    func deleteDocAndUser() {
        guard let userId = firebaseManager.userId else { return }
        firebaseManager.database.collection("users").document(userId)
            .delete { error in
                if let error {
                    self.showDeleteAccError()
                    print("error deleting user document", error.localizedDescription)
                    return
                }
                
                self.firebaseManager.auth.currentUser?.delete(completion: { error in
                    if let error {
                        print("error deleting user auth", error.localizedDescription)
                        self.showDeleteAccError()
                        return
                    }
                })
                self.userIsLoggedIn = false
                self.isAuthentificating = false
                print("successfully deleted account")
            }
    }

    private func showDeleteAccError() {
        self.createAlert(title: Strings.error, message: Strings.deleteAccError)
    }
}
