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
    
    var description: String {
        switch self {
        case .hetero: "Attraction to a different gender."
        case .homo: "Attraction to the same gender."
        case .bi: "Attraction to two or more genders."
        case .pan: "Attraction to people regardless of gender."
        case .asexual: "Little or no sexual attraction to others."
        case .queer: "A general term for sexual and gender minorities."
        case .questioning: "Exploring or questioning one's own sexual orientation."
        case .intersex: "Individuals born with reproductive or sexual anatomy that doesn’t fit typical definitions of female or male."
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
