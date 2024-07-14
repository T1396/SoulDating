//
//  SettingsView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 05.07.24.
//

import SwiftUI

struct SettingsView: View {
    // protocol is implemented by each SettingsEnum (AppSetting, ProblemSetting, JuridicalSetting)
    // so sheetItem can be any of the enums and we can use the attributes/functions defined in the protocol
    @EnvironmentObject var userVm: UserViewModel
    @State private var sheetItem: (any SettingEnumProtocol)?
    @State private var showSheet = false
    var body: some View {
        NavigationStack {
            Form {
                ForEach(AppSettingSections.allCases) { section in
                    Section(section.title) {
                        // Section enum has items attribut to display all section settings
                        ForEach(section.items, id: \.title) { item in
                            NavigationLink(destination: item.settingView) {
                                CustomLabel(text: item.title, systemName: item.icon)
                            }
                        }
                    }
                }

                Section("Logout") {
                    Button(action: logout) {
                        CustomLabel(text: Strings.logout, systemName: "rectangle.portrait.and.arrow.right.fill", labelRole: .delete)
                    }
                }
            }
            .alert(userVm.alertTitle, isPresented: $userVm.showAlert, actions: {
                if let action = userVm.onAcceptAction {
                    Button(Strings.cancel, role: .cancel, action: userVm.dismissAlert)
                    Button("OK", role: .destructive, action: action)
                } else {
                    Button(Strings.cancel, role: .cancel, action: userVm.dismissAlert)
                }
            }, message: {
                Text(userVm.alertMessage)
            })
            .toolbar(.hidden, for: .tabBar)

            .sheet(isPresented: Binding(
                get: { showSheet },
                set: { showSheet = $0 }
            ), onDismiss: { sheetItem = nil }, content: {
                sheetItem?.settingView // show related settingView from the enum
                    .presentationDetents([.medium, .large])
            })
            .navigationTitle(Strings.settingsTitle)
        }
    }

    private func logout() {
        withAnimation {
            userVm.attemptLogout()
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(UserViewModel())
}
