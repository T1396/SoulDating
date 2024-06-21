//
//  RegisterView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 06.06.24.
//

import SwiftUI

struct OnboardingUsernameView: View {
    // MARK: properties
    @StateObject private var onboardingViewModel = OnboardingViewModel()
    @EnvironmentObject var userViewModel: UserViewModel
    
    // MARK: computed properties
    var buttonBackground: Color {
        onboardingViewModel.isValidUserName ? .accentColor : .gray.opacity(0.7)
    }
    
    // MARK: body
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 10) {
                ProgressView(value: 0.2)
                    .tint(.cyan)
                Text("Welcome!")
                    .appFont(size: 40, textWeight: .bold)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Image(systemName: "hand.raised.app.fill")
                    .onboardingIconStyle()
                
                Text("Lets get started")
                    .appFont(size: 30, textWeight: .bold)
                
                Text("What is your name?")
                    .appFont(size: 24, textWeight: .medium)
                

                AppTextField(
                    "Username",
                    text: $onboardingViewModel.userDisplayName,
                    error: false,
                    errorMessage: "Your name must have at least 4 character",
                    supportText: "This will be your public profile name"
                )
                
                Spacer()
                
                NavigationLink(destination: OnboardingMoreInfoView(viewModel: onboardingViewModel)) {
                    Text("Continue")
                        .appButtonStyle(fullWidth: true)
                }
                .disabled(!onboardingViewModel.isValidUserName)
            }
            .padding()
        }
    }
}

#Preview {
    OnboardingUsernameView()
}
