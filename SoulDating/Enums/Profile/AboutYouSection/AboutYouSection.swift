//
//  AboutYouSection.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 20.06.24.
//

import Foundation

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
    
    func items(user: User) -> [AboutYouItem] {
        print(user)
        switch self {
        case .general:
            return [
                .name(user.name),
                .birthDate(user.birthDate),
                .gender(user.gender),
                .sex(user.general.sexuality),
                .location(user.location),
                .description(user.general.description)
            ]
        case .lookAndLifestyle:
            return [
                .height(user.look.height),
                .bodyType(user.look.bodyType),
                .job(user.general.job),
                .education(user.general.education),
                .drinkingBehaviour(user.general.drinkingBehaviour)
            ]
        case .moreInterests:
            return [
                .interests(user.general.interests ?? []),
                .languages(user.general.languages ?? []),
                .fashionStyle(user.look.fashionStyle),
                .fitnessLevel(user.look.fitnessLevel)
            ]
        }
    }
}


