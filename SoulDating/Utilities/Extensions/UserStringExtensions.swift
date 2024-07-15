//
//  UserStringExtensions.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 29.06.24.
//

import Foundation

extension FireUser {
    var heightString: String {
        guard let height = self.look.height else {
            return Strings.notSpecified
        }
        
        let locale = Locale.current
        let measurementSystem = locale.measurementSystem
        
        switch measurementSystem {
        case "Metric":
            let heightInMeters = Double(height) / 100.0
            return String(format: "%.2f meters", heightInMeters)
        case "Imperial":
            let totalInches = Int(Double(height) / 2.54)
            let feet = totalInches / 12
            let inches = totalInches % 12
            return "\(feet)' \(inches)\""
        default:
            return "\(height) cm (unhandled measurement system)"
        }
    }
    
    var ageAndGenderPrefString: String {
        guard let agePref = self.preferences.agePreferences,
              let genderPref = self.preferences.gender else {
            return Strings.notSpecified
        }
        
        let gendersString = genderPref.map { $0.title }.seperated(emptyText: Strings.all)
        return String(format: Strings.ageRangeString, gendersString, agePref.rangeString)
    }
    
}
