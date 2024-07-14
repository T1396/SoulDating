//
//  BugType.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 14.07.24.
//

import Foundation

enum BugType: String, CaseIterable, Identifiable, Codable {
    case ui, performance, crash, network, dataLoss, functionality, security, other

    var id: String { rawValue }

    var title: String {
        switch self {
        case .ui: Strings.bugTypeTitleUI
        case .performance: Strings.bugTypeTitlePerformance
        case .crash: Strings.bugTypeTitleCrash
        case .network: Strings.bugTypeTitleNetwork
        case .dataLoss: Strings.bugTypeTitleDataLoss
        case .functionality: Strings.bugTypeTitleFunctionality
        case .security: Strings.bugTypeTitleSecurity
        case .other: Strings.bugTypeTitleOther
        }
    }
    
    var icon: String {
        switch self {
        case .ui: return "laptopcomputer.and.iphone"
        case .performance: return "speedometer"
        case .crash: return "exclamationmark.triangle"
        case .network: return "antenna.radiowaves.left.and.right"
        case .dataLoss: return "externaldrive.badge.xmark"
        case .functionality: return "hammer"
        case .security: return "lock.shield"
        case .other: return "questionmark"
        }
    }
}
