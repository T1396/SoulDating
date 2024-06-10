//
//  User.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 04.06.24.
//

import Foundation

struct User: Codable {
    let id: String
    var userName: String?
    var birthDate: Date?
    var gender: Gender?
    var preferredGender: Gender?
    var onboardingCompleted: Bool?
    var location: LocationPreference?
    var interests: [String] = []
}

struct LocationPreference: Codable {
    let latitude: Double
    let longitude: Double
    let name: String
    let radius: Double // in km
}
