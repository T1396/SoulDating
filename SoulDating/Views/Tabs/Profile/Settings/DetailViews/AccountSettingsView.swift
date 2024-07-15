//
//  AccountSettingsView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 05.07.24.
//

import SwiftUI

struct AccountSettingsView: View {
    // MARK: properties
    enum Sheet: String, Identifiable {
        case mail, password
        
        var id: String { rawValue }
    }

    @StateObject private var settingsVm = SettingsViewModel()
    @Environment(\.dismiss) var dismiss
    @State private var sheet: Sheet?

    // MARK: body
    var body: some View {
        NavigationStack {
            Form {
                Section(Strings.personalDetailHeader) {
                    Button(action: openEditMailSheet) {
                        CustomLabel(text: Strings.email, systemName: "envelope.fill", showArrow: true)
                    }
                    Button(action: openEditPasswordSheet) {
                        CustomLabel(text: Strings.password, systemName: "key.fill", showArrow: true)
                    }
                }
                Section(Strings.accSectionHeader) {
                    Button(role: .destructive, action: settingsVm.attemptDeleteAccount) {
                        CustomLabel(text: Strings.deleteAccount, systemName: "trash.fill", showArrow: true, labelRole: .delete)
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle(Strings.accSettingsTitle)
        }
        .alert(settingsVm.alertTitle, isPresented: $settingsVm.showAlert) {
            if let action = settingsVm.onAcceptAction {
                Button(Strings.cancel, role: .cancel, action: settingsVm.dismissAlert)
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

    // MARK: functions
    
    private func openEditMailSheet() {
        sheet = .mail
    }

    private func openEditPasswordSheet() {
        sheet = .password
    }
}


#Preview {
    AccountSettingsView()
}
