//
//  Sexuality.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 20.06.24.
//

import Foundation

enum Sexuality: String, EditableItem, CaseIterable, Codable {
    case hetero, homo, bi, pan, asexual, queer, questioning, intersex
    
    var id: String { self.rawValue }
    
    var title: String {
        switch self {
        case .hetero: "Heterosexual"
        case .homo: "Homosexual"
        case .bi: "Bisexual"
        case .pan: "Pansexual"
        case .asexual: "Asexual"
        case .queer: "Queer"
        case .questioning: "Questioning"
        case .intersex: "Intersex"
        }
    }
    
    var icon: String {
        switch self {
        case .hetero: "figure.stand"
        case .homo: "figure.stand.line.dotted.figure.stand"
        case .bi: "figure.2.arms.open"
        case .pan: "figure.wave"
        case .asexual: "slash.circle"
        case .queer: "star.circle"
        case .questioning: "questionmark.circle"
        case .intersex: "circle.dashed"
        }
    }
}
