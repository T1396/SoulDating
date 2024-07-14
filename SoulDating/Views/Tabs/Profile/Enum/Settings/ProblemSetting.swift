//
//  ProblemSetting.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 07.07.24.
//

import Foundation
import SwiftUI

enum ProblemSetting: String, Identifiable, CaseIterable, SettingEnumProtocol {
    case help, reportBug

    var id: String { rawValue }

    var title: String {
        switch self {
        case .help: Strings.help
        case .reportBug: Strings.reportBugTitle
        }
    }

    var icon: String {
        switch self {
        case .help: "questionmark"
        case .reportBug: "ant.fill"
        }
    }

    var settingView: AnyView {
        switch self {
        case .help: AnyView(EmptyView())
        case .reportBug: AnyView(ReportBugView())
        }
    }
}
