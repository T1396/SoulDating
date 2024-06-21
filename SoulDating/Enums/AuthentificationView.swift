//
//  AuthMode.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 05.06.24.
//

import Foundation
import SwiftUI



enum AuthentificationView {
    case login, register
    
    var title: String {
        switch self {
        case .login: "Login"
        case .register: "Register"
        }
    }
    
    var altTitle: String {
        switch self {
        case .login: "Not registered yet? Click here"
        case .register: "Already have an account? Click here to login"
        }
    }
}
