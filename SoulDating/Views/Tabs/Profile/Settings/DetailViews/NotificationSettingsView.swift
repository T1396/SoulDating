//
//  NotificationSettingsView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 05.07.24.
//

import SwiftUI

/// not implemented due to no developer account so push notifications are not working
struct NotificationSettingsView: View {
    @State private var notificationsAllowed = true
    var body: some View {
        Form {
            Section(Strings.notificationSectionHeader) {
                Toggle(Strings.allowNotifications, isOn: $notificationsAllowed)
                    .toggleStyle(SymbolToggleStyle())
            }
        }
    }
}

#Preview {
    NotificationSettingsView()
}
