//
//  BugReport.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 14.07.24.
//

import Foundation

struct BugReport: Identifiable, Codable {
    var id: String = UUID().uuidString
    let userId: String?
    let bugType: BugType
    let bugDescription: String
    let additionalDescription: String
}
