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
            VStack {
                ProgressView(value: 0.2)
                Text("Wie ist dein Name?")
                    .titleStyle()
                Text("Anhand dieses Namens können dich andere Nutzer finden oder sehen")
                    .subTitleStyle()
                
                Spacer()
                
                AppTextField(
                    "Benutzername",
                    text: $onboardingViewModel.userDisplayName,
                    error: !onboardingViewModel.isValidUserName,
                    errorMessage: "Dein Name muss länger als 3 Zeichen sein",
                    supportText: "Dies wird dein öffentlicher Profilname"
                )
                
                Spacer()
                
                NavigationLink(destination: OnboardingGenderView(viewModel: onboardingViewModel)) {
                    Text("Weiter")
                        .textButtonStyle(color: buttonBackground)
                }
                .disabled(!onboardingViewModel.isValidUserName)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding()
        }
    }
}

#Preview {
    OnboardingUsernameView()
}
