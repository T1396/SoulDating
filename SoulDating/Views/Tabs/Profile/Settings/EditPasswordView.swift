//
//  EditPasswordView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 12.07.24.
//

import SwiftUI

struct EditPasswordView: View {
    @ObservedObject var settingsVm: SettingsViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            switch settingsVm.state {
            case .input:
                inputView()
            case .loading:
                LoadingView(message: Strings.changingPw)
            case .success:
                SuccessView(message: Strings.changedPwSuccess)
                    .onAppear {
                        executeDelayed {
                            // close sheet a few time after success
                            dismiss()
                        }
                    }
            }
        }
        .animation(.smooth, value: settingsVm.state)
        .padding()
    }

    @ViewBuilder
    private func inputView() -> some View {
        Text(Strings.changePw)
            .appFont(size: 22, textWeight: .bold)

        AppTextField(Strings.enterOldPassword, text: $settingsVm.password, error: settingsVm.password.count < 6, errorMessage: Strings.passwordHelpText, type: .password)

        AppTextField(Strings.repeatPassword, text: $settingsVm.passwordRepeat, error: settingsVm.passwordRepeat.count < 6, errorMessage: Strings.passwordHelpText, type: .password)

        AppTextField(Strings.enterNewPassword, text: $settingsVm.newPassword, error: settingsVm.newPassword.count < 6, errorMessage: Strings.passwordHelpText, type: .password)


        Button(action: settingsVm.changePassword) {
            Text(Strings.update)
                .appButtonStyle(fullWidth: true)
        }
        .disabled(settingsVm.updatePasswordDisabled)
    }

}
#Preview {
    EditPasswordView(settingsVm: SettingsViewModel())
}
