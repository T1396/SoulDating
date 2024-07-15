//
//  AppSetting.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 07.07.24.
//

import Foundation
import SwiftUI

enum AppSetting: String, Identifiable, CaseIterable, SettingEnumProtocol {
    case account, notifications, privacy

    var id: String { rawValue }

    var title: String {
        switch self {
        case .account: Strings.accSectionHeader
        case .notifications: Strings.notification
        case .privacy: Strings.privacySecurity
        }
    }

    var icon: String {
        switch self {
        case .account: "person.fill"
        case .notifications: "bell.fill"
        case .privacy: "key.fill"
        }
    }
    
    var settingView: AnyView {
        switch self {
        case .account: AnyView(AccountSettingsView())
        case .notifications: AnyView(NotificationSettingsView())
        case .privacy: AnyView(PrivacyView())
        }
    }
}
