//
//  SoulDatingApp.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 04.06.24.
//

import SwiftUI
import Firebase

@main
struct SoulDatingApp: App {
    @StateObject private var userViewModel = UserViewModel()

    init() {
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()
        let currentLanguageCode = Locale.current.language.languageCode?.identifier
        print("LanguageIdentifier: \(currentLanguageCode)")
        LanguageRepository.shared.loadLanguageData(for: currentLanguageCode ?? "en")
    }
    
    var body: some Scene {
        WindowGroup {
            if !userViewModel.userIsLoggedIn {
                if userViewModel.isAuthentificating {
                    ProgressView()
                } else {
                    SignInView()
                        .environmentObject(userViewModel)
                }
            } else {
                if !userViewModel.isAuthentificating {
                    if userViewModel.onboardingCompleted {
                        NavigationView()
                            .environmentObject(userViewModel)
                            .environmentObject(userViewModel.chatService)
                    } else {
                        OnboardingHostView()
                            .environmentObject(userViewModel)
                    }
                } else {
                    ProgressView()
                }
            }
        }
    }
}
