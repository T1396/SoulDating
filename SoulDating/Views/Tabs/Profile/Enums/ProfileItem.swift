//
//  ProfileItem.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 10.06.24.
//

import Foundation
import Firebase

enum ProfileItem: Identifiable {
    case name(String)
    case birthdate(Timestamp)
    case location(LocationPreference)
    case lookingFor(Gender)
    case interests([String])

    var id: String {
        switch self {
        case .name: return "Name"
        case .birthdate: return "Geburtstag"
        case .location: return "Standort"
        case .lookingFor: return "Auf der Suche nach"
        case .interests: return "Deine Interessen"
        }
    }
    
    var value: String {
        switch self {
        case .name(let name): name
        case .birthdate(let date): date.description
        case .location(let location): location.name
        case .lookingFor(let gender): gender.title
        case .interests(let array): array.description
        }
    }
    
    var editText: String {
        switch self {
        case .name(_): "Ändere deinen Nutzernamen"
        case .birthdate(_): "Aktualisiere deinen Geburtstag"
        case .location(_): "Aktualisiere deinen Standort"
        case .lookingFor(_): "Aktualisiere deine Nutzerpräferenzen"
        case .interests(_): "Aktualisiere deine allgemeinen Interessen"
        }
    }
}
