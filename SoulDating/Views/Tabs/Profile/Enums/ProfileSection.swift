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
        case .general(_):
            "Allgemein"
        case .about(_):
            "Weitere Infos über dich"
        case .preferences(_):
            "Preferenzen"
        }
    }
    
    var items: [ProfileItem] {
        switch self {
        case .general(let items), .about(let items), .preferences(let items):
            return items
        }
    }
    
    static func allSections(profile: User) -> [ProfileSection] {
            return [
                .general([
                    .name(profile.userName ?? ""),
                    .birthdate(profile.birthDate ?? .now),
                    .lookingFor(profile.preferredGender ?? .male)
                ]),
                .about([
                    .location(profile.location ?? Location(latitude: 0, longitude: 0, name: "Kein Standort eingetragen"))
                ]),
                .preferences([
                    .interests(profile.interests)
                ])
            ]
        }
}
