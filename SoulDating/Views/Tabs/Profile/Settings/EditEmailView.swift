//
//  EditEmailView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 12.07.24.
//

import SwiftUI


struct EditMailView: View {
    @ObservedObject var settingsVm: SettingsViewModel
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
            switch settingsVm.state {
            case .input:
                inputView()
            case .loading:
                LoadingView(message: Strings.linkToEmailSending)
            case .success:
                SuccessView(message: Strings.checkInbox)
                    .onAppear {
                        executeDelayed(completion: {
                            dismiss()
                        }, delay: 2.0)
                    }
            }
        }
        .animation(.smooth, value: settingsVm.state)
        .padding()

    }

    @ViewBuilder
    private func inputView() -> some View {
        Text(Strings.changeMail)
            .appFont(size: 22, textWeight: .bold)

        AppTextField(Strings.enterMail, text: .constant(settingsVm.email), error: false, errorMessage: Strings.emailHelpText, type: .normal, keyboardType: .emailAddress)
            .disabled(true)

        AppTextField(Strings.enterNewMail, text: $settingsVm.newMail, error: settingsVm.newMail.count < 6, errorMessage: Strings.emailHelpText, type: .normal, keyboardType: .emailAddress)

        AppTextField(Strings.enterPassword, text: $settingsVm.password, error: settingsVm.password.count < 6, errorMessage: Strings.passwordHelpText, type: .password)


        Button(action: changeMail) {
            Text(Strings.update)
                .appButtonStyle(fullWidth: true)
        }
        .disabled(settingsVm.emailChangeDisabled)
    }

    private func changeMail() {
        settingsVm.attemptChangeMail()
    }
}


#Preview {
    EditMailView(settingsVm: SettingsViewModel())
}
