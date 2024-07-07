//
//  AccountSettingsView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 05.07.24.
//

import SwiftUI

struct AccountSettingsView: View {
    enum Sheet: String, Identifiable {
        case mail, password
        
        var id: String { rawValue }
    }

    @StateObject private var settingsVm = SettingsViewModel()
    @Environment(\.dismiss) var dismiss
    @State private var sheet: Sheet?
    var body: some View {
        NavigationStack {
            Form {
                Section("Personal Details") {
                    Button(action: {
                        sheet = .mail
                    }, label: {
                        CustomLabel(text: "Email address", systemName: "envelope.fill", showArrow: true)
                    })
                    Button(action: {
                        sheet = .password
                    }, label: {
                        CustomLabel(text: "Password", systemName: "key.fill", showArrow: true)
                    })
                }
                Section("Account") {
                    Button(role: .destructive, action: deleteAccount) {
                        CustomLabel(text: "Delete your Account", systemName: "trash.fill", showArrow: true, labelRole: .delete)
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("Account Settings")
        }
        .alert(settingsVm.alertTitle, isPresented: $settingsVm.showAlert) {
            if let action = settingsVm.onAcceptAction {
                Button("Cancel", role: .cancel, action: settingsVm.dismissAlert)
                Button("OK", role: .destructive, action: action)
            } else {
                Button("OK", role: .destructive, action: settingsVm.dismissAlert)
            }
        } message: {
            Text(settingsVm.alertMessage)
        }
        .sheet(item: $sheet) { sheet in
            switch sheet {
            case .mail:
                EditMailView(settingsVm: settingsVm)
                    .presentationDetents([.medium, .large])
            case .password:
                EditPasswordView(settingsVm: settingsVm)
                    .presentationDetents([.medium])
            }
        }
    }

    private func deleteAccount() {
        settingsVm.attemptDeleteAccount()
    }
}

struct EditMailView: View {
    @ObservedObject var settingsVm: SettingsViewModel
    @State private var mail = ""
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
            switch settingsVm.state {
            case .input:
                inputView()
            case .loading:
                LoadingView(message: "A link is beeing send to your new email address")
            case .success:
                SuccessView(message: "Check the inbox of you mail to update your email address and login again.")
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
        Text("Change your e-mail address")
            .appFont(size: 22, textWeight: .bold)


        AppTextField(Strings.enterMail, text: .constant(settingsVm.email), error: false, errorMessage: nil, supportText: "", type: .email)
            .disabled(true)

        AppTextField(Strings.enterNewMail, text: $settingsVm.newMail, error: mail.count < 6, errorMessage: Strings.enterValidMail, supportText: "", type: .email)

        AppTextField(Strings.enterPassword, text: $settingsVm.password, error: false, errorMessage: nil, supportText: "", type: .password)


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

struct EditPasswordView: View {
    @ObservedObject var settingsVm: SettingsViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            switch settingsVm.state {
            case .input:
                inputView()
            case .loading:
                LoadingView(message: "Your password is beeing changed")
            case .success:
                SuccessView(message: "Successfully changed your password!")
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
        Text("Change your password")
            .appFont(size: 22, textWeight: .bold)

        AppTextField(Strings.enterOldPassword, text: $settingsVm.password, error: settingsVm.password.count < 6, errorMessage: Strings.enterOldPassword, supportText: "", type: .password)

        AppTextField(Strings.repeatPassword, text: $settingsVm.passwordRepeat, error: false, errorMessage: nil, supportText: "", type: .password)

        AppTextField(Strings.enterNewPassword, text: $settingsVm.newPassword, error: settingsVm.newPassword.count < 6, errorMessage: Strings.enterValidMail, supportText: "", type: .password)


        Button(action: settingsVm.changePassword) {
            Text(Strings.update)
                .appButtonStyle(fullWidth: true)
        }
        .disabled(settingsVm.updatePasswordDisabled)
    }

}

#Preview {
    AccountSettingsView()
}
