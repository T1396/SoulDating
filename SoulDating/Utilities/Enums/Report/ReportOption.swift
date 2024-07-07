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
        case .block: "Block \(userName)"
        case .blockReport: "Block and report \(userName)"
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
        case .block: "Do you really want to block \(userName)?"
        case .blockReport: "Do you really want to report and block \(userName)?"
        }
    }
    
    func confirmationMessage(for userName: String) -> String {
        switch self {
        case .block: "You can unblock \(userName) at every time."
        case .blockReport: "You can unblock \(userName), but your report cannot be undone!"
        }
    }
}
