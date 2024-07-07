//
//  ProfileSection.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 10.06.24.
//

import Foundation

enum ProfileSection: Identifiable {
    case general([ProfileItem])
    case about([ProfileItem])
    case preferences([ProfileItem])
 
    
    var id: String {
        self.title
    }
    
    var title: String {
        switch self {
        case .general: "General"
        case .about: "More about you"
        case .preferences: "Preferences"
        }
    }
    
    var items: [ProfileItem] {
        switch self {
        case .general(let items), .about(let items), .preferences(let items):
            return items
        }
    }
    
    static func allSections(profile: User) -> [ProfileSection] {
            [
                .general([
                    .name(profile.name ?? ""),
                    .birthdate(profile.birthDate ?? .now.subtractYears(18)),
                    .gender(profile.gender ?? .male),
                    .location(profile.location ?? LocationPreference(latitude: 0, longitude: 0, name: "", radius: profile.location?.radius ?? 0)),
                    .ageRangePreference(profile.preferences?.agePreferences)
                ]),
                .about([
                    .description(profile.general?.description),
                    .height(profile.look?.height),
                    .job(profile.general?.job),
                    .languages(profile.general?.languages ?? []),
                    .smokingStatus(profile.general?.smokingStatus ?? .none),
                    .interests(profile.general?.interests ?? [])
                    
                ]),
                .preferences([
                    .preferredGender(profile.preferences?.gender?.first ?? Gender.randomGender()),
                    .heightPreference(profile.preferences?.height)
                ])
            ]
        }
}
