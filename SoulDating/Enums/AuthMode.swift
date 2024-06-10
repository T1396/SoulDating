//
//  AuthMode.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 05.06.24.
//

import Foundation
import SwiftUI



enum AuthMode {
    case login, register
    
    var title: String {
        switch self {
        case .login: "Anmelden"
        case .register: "Registrieren"
        }
    }
    
    var altTitle: String {
        switch self {
        case .login: "Noch kein Konto? Registrieren"
        case .register: "Schon registriert? Anmelden"
        }
    }
}
