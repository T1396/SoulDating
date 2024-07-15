//
//  ReportOption.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 16.06.24.
//

import Foundation

enum ReportOption: String, CaseIterable, Identifiable {
    case block, blockReport
    
    var id: String { rawValue }
    
    func title(for userName: String) -> String {
        switch self {
        case .block: String(format: Strings.blockTitle, userName)
        case .blockReport: String(format: Strings.blockReportTitle, userName)
        }
    }
    
    var icon: String {
        switch self {
        case .block: "minus.circle.fill"
        case .blockReport: "flag.fill"
        }
    }
    
    func confirmationTitle(for userName: String) -> String {
        switch self {
        case .block: String(format: Strings.confirmationBlock, userName)
        case .blockReport: String(format: Strings.confirmationReport, userName)
        }
    }
    
    func confirmationMessage(for userName: String) -> String {
        switch self {
        case .block: String(format: Strings.confirmationMsgBlock, userName)
        case .blockReport: String(format: Strings.confirmationMsgReport, userName)
        }
    }
}
