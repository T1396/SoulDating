//
//  AboutYouSection.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 20.06.24.
//

import Foundation
import SwiftUI



enum AboutYouSection: String, Identifiable, CaseIterable {
    case general, lookAndLifestyle, moreInterests
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .general: "General Information"
        case .lookAndLifestyle: "Look & Lifestyle"
        case .moreInterests: "Your Interests"
        }
    }

    func items() -> [any AboutYouItemProtocol] {
            switch self {
            case .general:
                return GeneralItem.allCases.map { $0 as any AboutYouItemProtocol }
            case .lookAndLifestyle:
                return LookAndLifeStyleItem.allCases.map { $0 as any AboutYouItemProtocol }
            case .moreInterests:
                return MoreAboutYouItem.allCases.map { $0 as any AboutYouItemProtocol }
            }
        }
}
