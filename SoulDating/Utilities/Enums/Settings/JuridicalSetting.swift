//
//  JuridicalSetting.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 07.07.24.
//

import Foundation
import SwiftUI

enum JuridicalSetting: String, Identifiable, CaseIterable, SettingEnumProtocol {
    case dataProtection, agb

    var id: String { rawValue }

    var title: String {
        switch self {
        case .dataProtection: "Data protection"
        case .agb: "General terms and conditions"
        }
    }

    var icon: String {
        switch self {
        case .dataProtection: "bolt.shield"
        case .agb: "pencil.line"
        }
    }

    var settingView: AnyView {
        switch self {
        case .dataProtection: AnyView(EmptyView())
        case .agb: AnyView(EmptyView())
        }
    }
}
