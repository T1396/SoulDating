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
        case .casual: "Casual"
        case .business: "Business Casual"
        case .formal: "Formal"
        case .sporty: "Sporty"
        case .eclectic: "Eclectic"
        case .vintage: "Vintage"
        case .streetwear: "Streetwear"
        case .chic: "Chic"
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
