//
//  Error.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 11.06.24.
//

import Foundation

enum FirebaseError: Error, CustomStringConvertible {
    case notLoggedIn, downloadUrlFailure, nopicturechosen, convertError
    
    var description: String {
        switch self {
        case .notLoggedIn: Strings.notLoggedIn
        case .downloadUrlFailure: Strings.downloadUrlFail
        case .nopicturechosen: Strings.noPictureChosen
        case .convertError: Strings.convertError
        }
    }
    
    var displayMessage: String {
        switch self {
        case .notLoggedIn: Strings.notLoggedInMsg
        case .downloadUrlFailure: Strings.downloadUrlFailMsg
        case .nopicturechosen: Strings.noPictureChosenMsg
        case .convertError: Strings.convertErrorMsg
        }
    }
}
