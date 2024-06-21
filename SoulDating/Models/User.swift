//
//  User.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 04.06.24.
//

import Foundation
import Firebase

struct User: Codable {
    let id: String
    var userName: String?
    var profileImageUrl: String?
    var birthDate: Timestamp?
    var gender: Gender?
    var preferredGender: Gender?
    var onboardingCompleted: Bool?
    var location: LocationPreference?
    var interests: [String]?
    var minAge: Double?
    var maxAge: Double?
}

struct LocationPreference: Codable {
    let latitude: Double
    let longitude: Double
    let name: String
    let radius: Double // in km
}
