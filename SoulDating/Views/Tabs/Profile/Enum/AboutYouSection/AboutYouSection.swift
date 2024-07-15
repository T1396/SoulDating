//
//  AboutYouSection.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 20.06.24.
//

import Foundation
import SwiftUI

// AboutYou View has 3 Sections
// the function items uses an protocol any section enum implements so that in the profileView it can be used generically to show e.g. editViews of each items (generalItem, LookAndLifestyle and so on)


enum AboutYouSection: String, Identifiable, CaseIterable {
    case general, lookAndLifestyle, moreAboutYou

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .general: Strings.generalTitle
        case .lookAndLifestyle: Strings.lookAndLifestyleTitle
        case .moreAboutYou: Strings.moreAboutYouTitle
        }
    }

    func items() -> [any AboutYouItemProtocol] {
        switch self {
        case .general:
            return GeneralItem.allCases.map { $0 as any AboutYouItemProtocol }
        case .lookAndLifestyle:
            return LookAndLifeStyleItem.allCases.map { $0 as any AboutYouItemProtocol }
        case .moreAboutYou:
            return MoreAboutYouItem.allCases.map { $0 as any AboutYouItemProtocol }
        }
    }
}
