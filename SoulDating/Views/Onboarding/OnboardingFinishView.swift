//
//  OnboardingFinishView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 07.07.24.
//

import SwiftUI

struct OnboardingFinishView: View {
    @Binding var isOnboardingFinished: Bool

    @EnvironmentObject var userVm: UserViewModel

    var body: some View {
        VStack {
            if !isOnboardingFinished {
                LoadingView(message: Strings.accBeeingCreated)
            } else {
                SuccessView(message: Strings.accWasCreated)

                Button {
                    withAnimation {
                        userVm.updateOnboardingStatus()
                    }
                } label: {
                    Text(Strings.continues)
                        .appButtonStyle(fullWidth: true)
                }
            }
        }
        .padding()
    }
}

#Preview {
    OnboardingFinishView(isOnboardingFinished: .constant(false))
}
