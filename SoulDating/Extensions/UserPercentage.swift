//
//  UserPercentage.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 24.06.24.
//

import SwiftUI


/// calculated the percentage of information a user has provided to display it in the app e.g. '20% Completed'" 
/// uses the mirror class from swift library  to use reflection which can inspect attributes on structs like the user and his substructs

/// protocol which all structs that need a calculation should implement
protocol Reflectable {}

/// let user and substructs we want to calculate implement reflectable protocol to identify substructs in countProperties function
extension User: Reflectable {}
extension UserGeneral: Reflectable {}
extension Look: Reflectable {}
extension Preferences: Reflectable {}

/// useful to check if a field is nil or not, because optional isnt member of any class/protocol
protocol OptionalProtocol {
    func isNil() -> Bool
}

extension Optional: OptionalProtocol {
    func isNil() -> Bool {
        return self == nil
    }
}

extension Reflectable {
    /// calculates the total amount of fields of a struct, and if the struct has fields that are structs too, the function calls itself recursively to get the total amount
    /// - Parameters:
    ///  - excludedProperties: set containing field names which should be not included in the calculation
    /// - Returns: a tuple containing the total amount of not nil fields and the total amount of fields
    func countProperties(excluding excludedProperties: Set<String> = []) -> (nonNilCount: Int, totalCount: Int) {
        let mirror = Mirror(reflecting: self)
        var nonNilCount = 0
        var totalCount = 0

        for child in mirror.children {
            guard let propertyName = child.label else {
                continue
            }
            // skip excluded fields
            if excludedProperties.contains(propertyName) {
                continue
            }

            // check if the field implements reflectable, meaning it is a substruct we need to count too
            if let value = child.value as? Reflectable {
                // call function recursively if the field
                let nestedCounts = value.countProperties(excluding: excludedProperties)
                nonNilCount += nestedCounts.nonNilCount
                totalCount += nestedCounts.totalCount
            } else {
                totalCount += 1
                if let optional = child.value as? OptionalProtocol, !optional.isNil() {
                    // field is optional but not nil
                    nonNilCount += 1
                } else if !(child.value is OptionalProtocol) {
                    // field is non optional
                    nonNilCount += 1
                }
            }
        }
        return (nonNilCount, totalCount)
    }
}



extension User {
    var totalPercent: Double {
        let excludedFields: Set<String> = ["id", "blockedUsers", "onboardingCompleted", "registrationDate"]
        let counts = self.countProperties(excluding: excludedFields)
        print(counts.totalCount)
        print(counts.nonNilCount)
        let percentageFilled = Double(counts.nonNilCount) / Double(counts.totalCount) * 100
        return percentageFilled
    }
}


