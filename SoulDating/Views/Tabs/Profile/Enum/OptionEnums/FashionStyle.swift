//
//  FashionStyle.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 20.06.24.
//

import Foundation

enum FashionStyle: String, EditableItem, Identifiable, CaseIterable, Codable {
    case casual, business, formal, sporty, eclectic, vintage, streetwear, chic

    var id: String { rawValue }

    var title: String {
        switch self {
        case .casual: Strings.casual
        case .business: Strings.business
        case .formal: Strings.formal
        case .sporty: Strings.sporty
        case .eclectic: Strings.eclectic
        case .vintage: Strings.vintage
        case .streetwear: Strings.streetwear
        case .chic: Strings.chic
        }
    }

    var icon: String {
        switch self {
        case .casual: "tshirt.fill"
        case .business: "briefcase.fill"
        case .formal: "suit.club.fill"
        case .sporty: "figure.walk"
        case .eclectic: "aqi.medium"
        case .vintage: "clock.fill"
        case .streetwear: "shoe.2.fill"
        case .chic: "star.fill"
        }
    }
}
