//
//  AuthMode.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 05.06.24.
//

import Foundation
import SwiftUI



enum AuthentificationMode {
    case login, register
    
    var title: String {
        switch self {
        case .login: Strings.login
        case .register: Strings.register
        }
    }
    
    var altTitle: String {
        switch self {
        case .login: Strings.notRegisteredYet
        case .register: Strings.alreadyRegistered
        }
    }
}
