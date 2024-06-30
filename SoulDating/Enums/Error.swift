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
        case .notLoggedIn:
            return "User is not logged in"
        case .downloadUrlFailure:
            return "URL of the picture couldn't be downloaded"
        case .nopicturechosen:
            return "No image chosen or the picture could not be set to the variable"
        case .convertError:
            return "An error occured while converting"
        }
    }
    
    var displayMessage: String {
        switch self {
        case .notLoggedIn:
            "Oops! You are not logged in. If this should not be the case submit a bugreport."
        case .downloadUrlFailure:
            "We couldn't download the image from the server... Please check your connection and try again"
        case .nopicturechosen:
            "An error occured and it seems you have no image selected, try again"
        case .convertError:
            "Something went wrong... Please try again or submit a bugreport."
        }
    }
}
