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
    }
    
    var body: some Scene {
        WindowGroup {
            if !userViewModel.userIsLoggedIn {
                if userViewModel.isAuthentificating {
                    ProgressView()
                }
                
                ProgressView()
            } else {
                
            }
            
            
            if userViewModel.userIsLoggedIn {
                if userViewModel.onboardingCompleted {
                    NavigationView()
                        .environmentObject(userViewModel)
                } else {
                    OnboardingUsernameView()
                        .environmentObject(userViewModel)
                }
            } else {
                SignInView()
                    .environmentObject(userViewModel)
            }
        }
    }
}
