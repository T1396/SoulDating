//
//  Error.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 11.06.24.
//

import Foundation

enum FirebaseError: Error {
    case notLoggedIn, downloadUrlFailure, nopicturechosen
}
