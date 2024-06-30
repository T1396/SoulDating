//
//  SignInSheet.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 05.06.24.
//

import SwiftUI

enum SignInState {
    case showSignOptions, enterDetails
}

struct SignInSheet: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var signInState: SignInState = .showSignOptions
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                if signInState == .showSignOptions {
                    authOptionsView
                } else {
                    emailSignInView
                }
                Spacer()
                
                Button(action: switchAuthentificationMode) {
                    Text(userViewModel.switchModeText)
                        .padding()
                }
                .navigationTitle(userViewModel.mode.title)
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
    
    private func switchAuthentificationMode() {
        withAnimation {
            userViewModel.switchAuthMode()
        }
    }
    
    var authOptionsView: some View {
        VStack {
            HStack(spacing: 30) {
                VStack {
                    Image(systemName: "phone.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .padding()
                        .background(.gray.opacity(0.2))
                        .clipShape(Circle())
                    Text("Telefon")
                }
                
                VStack {
                    Image("google")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .padding()
                        .background(.gray.opacity(0.2))
                        .clipShape(Circle())
                    Text("Google")
                }
                
                VStack {
                    Image(systemName: "apple.logo")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .padding()
                        .background(.gray.opacity(0.2))
                        .clipShape(Circle())
                    Text("Apple")
                }
            }
            Divider().padding(.top, 12)
            Button(action: showEnterSignInDetails) {
                Text(userViewModel.emailModeText)
                    .foregroundStyle(.blue.opacity(0.7))
                    .padding()
            }
            Divider()
        }
    }
    
    
    var emailSignInView: some View {
        VStack(spacing: 12) {
            Button(action: showSignInOptions) {
                Image(systemName: "chevron.backward")
                Text("Sign in options")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            AppTextField(
                "E-Mail",
                text: $userViewModel.email,
                error: userViewModel.email.count < 6,
                errorMessage: "This is no valid E-Mail"
            )
            
            AppTextField(
                "Passwort",
                text: $userViewModel.password,
                error: userViewModel.password.count < 5,
                errorMessage: "The password must contain at least 6 chraracters",
                type: .password
            )
            
            if userViewModel.mode == .register {
                AppTextField(
                    "Passwort wiederholen",
                    text: $userViewModel.passwordRepeat,
                    error: !userViewModel.passwordMatches,
                    errorMessage: "The passwords are not equal",
                    type: .password
                )
            }
            
            // Login or Sign in Button
            Button(userViewModel.mode.title, action: userViewModel.signIn)
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 24)
    }
    
    private func showSignInOptions() {
        withAnimation {
            signInState = .showSignOptions
        }
    }
    
    
    private func showEnterSignInDetails() {
        withAnimation {
            signInState = .enterDetails
        }
    }
}

#Preview {
    SignInSheet()
        .environmentObject(UserViewModel())
}
