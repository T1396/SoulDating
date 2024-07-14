//
//  AppSettingSection.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 07.07.24.
//

import Foundation
import SwiftUI

protocol SettingEnumProtocol {
    var title: String { get }
    var icon: String { get }
    var settingView: AnyView { get }
}

enum AppSettingSections: String, Identifiable, CaseIterable {
    case appSettings, problems

    var id: String { rawValue }

    var title: String {
        switch self {
        case .appSettings: Strings.appSettings
        case .problems: Strings.problems
        }
    }

    var items: [any SettingEnumProtocol] {
        switch self {
        case .appSettings:
            AppSetting.allCases.map { $0 as any SettingEnumProtocol }
        case .problems:
            ProblemSetting.allCases.map { $0 as any SettingEnumProtocol }
        }
    }
}
