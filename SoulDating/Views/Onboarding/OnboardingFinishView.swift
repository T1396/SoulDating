//
//  OnboardingFinishView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 07.07.24.
//

import SwiftUI

struct OnboardingFinishView: View {
    @Binding var isOnboardingFinished: Bool

    var body: some View {
        if !isOnboardingFinished {
            LoadingView(message: "Your account is beeing created and your details saved! Hold on a second")
        } else {
            SuccessView(message: "Your new account was created. You can continue with SoulDating!")

            Button {

            } label: {
                Text(Strings.continues)
                    .appButtonStyle(fullWidth: true)
            }
        }
    }
}

#Preview {
    OnboardingFinishView(isOnboardingFinished: .constant(false))
}
