//
//  ProblemSetting.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 07.07.24.
//

import Foundation
import SwiftUI

enum ProblemSetting: String, Identifiable, CaseIterable, SettingEnumProtocol {
    case help, aboutSoulDating

    var id: String { rawValue }

    var title: String {
        switch self {
        case .help: "Help"
        case .aboutSoulDating: "About Souldating"
        }
    }

    var icon: String {
        switch self {
        case .help: "questionmark"
        case .aboutSoulDating: "info"
        }
    }

    var settingView: AnyView {
        switch self {
        case .help: AnyView(EmptyView())
        case .aboutSoulDating: AnyView(EmptyView())
        }
    }
}
