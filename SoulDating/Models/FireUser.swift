//
//  User.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 04.06.24.
//

import Foundation
import Firebase

struct FireUser: Codable, Identifiable, Equatable, Hashable {
    let id: String
    var name: String?
    var isHidden: Bool = false
    var profileImageUrl: String?
    var birthDate: Date?
    var gender: Gender?
    var onboardingCompleted: Bool?
    var general = UserGeneral()
    var location = Location()
    var look = Look()
    var preferences = Preferences()
    var blockedUsers: [String]?
    var registrationDate: Date?
}


extension FireUser {
    var age: Int? {
        guard let birthDate else { return nil }
        let calendar = Calendar.current
        let now = Date()
        let ageComponents = calendar.dateComponents([.year], from: birthDate, to: now)
        return ageComponents.year
    }

    var nameAgeString: String {
        if let age, let name {
            return "\(name), \(age)"
        } else {
            return "Anonymous"
        }
    }
}

struct UserGeneral: Codable, Equatable, Hashable {
    var education: EducationLevel = .none
    var smokingStatus: SmokeLevel = .nonSmoker
    var sexuality: Sexuality?
    var job: String?
    var languages: [String]? // list of keys in languages.json
    var drinkingBehaviour: DrinkingBehaviour?
    var interests: [Interest]?
    var description: String?
}

struct Look: Codable, Equatable, Hashable {
    var height: Double?
    var bodyType: BodyType = .average
    var fashionStyle: FashionStyle = .casual
    var fitnessLevel: FitnessLevel?
}


struct Preferences: Codable, Equatable, Hashable {
    var height: Double?
    var wantsChilds: Bool?
    var smoking: Bool?
    var sports: Bool?
    var drinking: Bool?
    var relationshipType: RelationshipType?
    var gender: [Gender]?
    var agePreferences: AgePreference?
} 

struct AgePreference: Codable, Equatable, Hashable {
    var minAge: Double
    var maxAge: Double
}

struct Location: Codable, Equatable, Hashable {
    var latitude: Double = -100
    var longitude: Double = 133.0
    var name: String = "No location set."
    var radius: Double = 100 // in km
}

extension FireUser {
    // helps to refetch users when something important like preferred genders changed
    func hasRelevantDataChangesToRefetch(from oldUser: FireUser) -> Bool {
        self.preferences.gender != oldUser.preferences.gender ||
        self.preferences.agePreferences != oldUser.preferences.agePreferences ||
        self.location != oldUser.location ||
        self.blockedUsers != oldUser.blockedUsers
    }
}

extension AgePreference {
    func toDictionary() -> [String: Any] {
        let dict: [String: Any] = [
            "minAge": minAge,
            "maxAge": maxAge
        ]
        return dict
    }

    var rangeString: String {
        if let minAgeStr = minAge.formatted(as: .decimal, maxFractionDigits: 0, locale: .autoupdatingCurrent),
           let maxAgeStr = maxAge.formatted(as: .decimal, maxFractionDigits: 0, locale: .autoupdatingCurrent) {
            return "\(minAgeStr) - \(maxAgeStr)"
        }
        return "all"
    }
}

extension Location {
    func toDictionary() -> [String: Any] {
        [
            "latitude": latitude,
            "longitude": longitude,
            "name": name as Any,
            "radius": radius
        ]
    }
}
