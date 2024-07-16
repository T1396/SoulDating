//
//  OnboardingHostView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 07.07.24.
//

import SwiftUI

struct OnboardingHostView: View {
    // MARK: properties
    @StateObject private var onboardingVm = OnboardingViewModel()
    @EnvironmentObject var userVm: UserViewModel


    @State private var progress: Double = 0
    @State private var stepIndex = 0
    @State private var isOnboardingFinished = false
    @State private var navigationTransitionForward = true

    // MARK: body
    var body: some View {
        NavigationStack {
            VStack {
                if stepIndex < 5 {
                    ProgressView(value: progress)
                        .tint(.accent.opacity(0.7))
                }

                if !onboardingVm.hasCriticalError {
                    if stepIndex > 0 && stepIndex < 5 {
                        BackArrow {
                            // ensures the transition is mirrored when navigating back
                            navigationTransitionForward = false
                            withAnimation {
                                stepIndex -= 1
                            } completion: {
                                navigationTransitionForward = true
                            }
                            if progress >= 0.2 {
                                progress -= 0.2
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    Group {
                        switch stepIndex {
                        case 0:
                            OnboardingUsernameView(viewModel: onboardingVm, progress: $progress, stepIndex: $stepIndex)
                        case 1:
                            OnboardingMoreInfoView(viewModel: onboardingVm, progress: $progress, stepIndex: $stepIndex)
                        case 2:
                            OnboardingPictureView(viewModel: onboardingVm, progress: $progress, stepIndex: $stepIndex)
                        case 3:
                            OnboardingNotificationView(viewModel: onboardingVm, progress: $progress, stepIndex: $stepIndex)
                        case 4:
                            OnboardingLocationView(viewModel: onboardingVm, progress: $progress, stepIndex: $stepIndex, isOnboardingSuccessfully: $isOnboardingFinished)
                        default:
                            OnboardingFinishView(isOnboardingFinished: $isOnboardingFinished)
                        }
                    }
                    .transition(.asymmetric(
                        insertion: navigationTransitionForward ? .move(edge: .trailing) : .move(edge: .leading),
                        removal: navigationTransitionForward ? .move(edge: .leading) : .move(edge: .trailing)
                    ))
                } else {
                    // any critical error occured while onboarding
                    Text(Strings.unexpectedCriticalBug)
                        .appFont(size: 20, textWeight: .bold)
                        .padding()

                    Button {
                        onboardingVm.sendBugReport()
                    } label: {
                        Text(Strings.sendReport)
                            .appButtonStyle()
                    }
                    
                    Button(action: resetDocAndReturn) {
                        Text(Strings.createNewAccount)
                            .appButtonStyle()
                    }
                }
            }

            .alert(onboardingVm.alertTitle, isPresented: $onboardingVm.showAlert) {
                if let action = onboardingVm.onAcceptAction {
                    Button(Strings.cancel, action: onboardingVm.dismissAlert)
                    Button(onboardingVm.onAcceptText, action: action)
                } else {
                    Button(Strings.cancel, action: onboardingVm.dismissAlert)
                }
            } message: {
                Text(onboardingVm.alertMessage)
            }

            .alert(userVm.alertTitle, isPresented: $userVm.showAlert) {
                Button("OK", action: userVm.dismissAlert)
            } message: {
                Text(userVm.alertMessage)
            }

        }
    }

    private func resetDocAndReturn() {
        userVm.deleteDocAndUser()
    }
}

#Preview {
    OnboardingHostView()
        .environmentObject(UserViewModel())
}
