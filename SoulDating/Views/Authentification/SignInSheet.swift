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
    @Binding var isPresented: Bool

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                emailSignInView

                Spacer()
                
                Button(action: switchAuthentificationMode) {
                    Text(userViewModel.switchModeText)
                        .padding()
                }
                .navigationTitle(userViewModel.mode.title)
                .navigationBarTitleDisplayMode(.inline)
            }

            .alert(userViewModel.alertTitle, isPresented: $userViewModel.showAlert) {
                Button("OK", action: userViewModel.dismissAlert)
            } message: {
                Text(userViewModel.alertMessage)
            }

        }
    }
    
    private func switchAuthentificationMode() {
        withAnimation {
            userViewModel.switchAuthMode()
        }
    }
    
//    var authOptionsView: some View {
//        VStack {
//            Divider().padding(.top, 12)
//            Button(action: showEnterSignInDetails) {
//                Text(userViewModel.emailModeText)
//                    .foregroundStyle(.blue.opacity(0.7))
//                    .padding()
//            }
//            Divider()
//        }
//    }
    
    
    var emailSignInView: some View {
        VStack(spacing: 12) {
            Button(action: showSignInOptions) {
                Image(systemName: "chevron.backward")
                Text(Strings.signInOptions)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            AppTextField(
                Strings.email,
                text: $userViewModel.email,
                error: userViewModel.email.count < 6,
                errorMessage: "This is no valid E-Mail",
                keyboardType: .emailAddress
            )
            .padding(.top, 24)

            AppTextField(
                Strings.password,
                text: $userViewModel.password,
                error: userViewModel.password.count < 5,
                errorMessage: "The password must contain at least 6 chraracters",
                type: .password
            )
            
            if userViewModel.mode == .register {
                AppTextField(
                    Strings.repeatPassword,
                    text: $userViewModel.passwordRepeat,
                    error: !userViewModel.passwordMatches,
                    errorMessage: "The passwords are not equal",
                    type: .password
                )
            }
            
            // Login or Sign in Button
            Button(action: signIn) {
                Text(userViewModel.mode.title)
                    .appButtonStyle(fullWidth: true)
            }
        }
        .padding(.horizontal, 24)
    }
    
    private func showSignInOptions() {
        withAnimation {
            signInState = .showSignOptions
        }
    }

    private func signIn() {
        withAnimation {
            userViewModel.signIn()
            isPresented = false
        }
    }

    
    private func showEnterSignInDetails() {
        withAnimation {
            signInState = .enterDetails
        }
    }
}

#Preview {
    SignInSheet(isPresented: .constant(true))
        .environmentObject(UserViewModel())
}
