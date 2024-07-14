//
//  RegisterView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 06.06.24.
//

import SwiftUI

struct OnboardingUsernameView: View {
    // MARK: properties
    @ObservedObject var viewModel: OnboardingViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @Binding var progress: Double
    @Binding var stepIndex: Int
    
    // MARK: body
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 10) {
                Text(Strings.welcome)
                    .appFont(size: 40, textWeight: .bold)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Image(systemName: "hand.raised.app.fill")
                    .onboardingIconStyle()
                
                Text(Strings.letsGetStarted)
                    .appFont(size: 30, textWeight: .bold)
                
                Text(Strings.whatsName)
                    .appFont(size: 24, textWeight: .medium)
                

                AppTextField(
                    Strings.userName,
                    text: $viewModel.userDisplayName,
                    error: viewModel.userDisplayName.count < 3,
                    errorMessage: Strings.atleast3Chars
                )
                
                Spacer()
                
                Button(action: goToNextPage) {
                    Text(Strings.continues)
                        .appButtonStyle(fullWidth: true)
                }
                .disabled(!viewModel.isValidUserName)


            }
            .padding()

            .onAppear {
                withAnimation {
                    progress = 0.2
                }
            }
        }
    }
    
    // MARK: functions
    private func goToNextPage() {
        // closes keyboard...
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)

        withAnimation {
            stepIndex += 1 // go to next onboarding page
        }
    }
}

#Preview {
    OnboardingUsernameView(viewModel: OnboardingViewModel(), progress: .constant(0.2), stepIndex: .constant(1))
        .environmentObject(UserViewModel())
}
