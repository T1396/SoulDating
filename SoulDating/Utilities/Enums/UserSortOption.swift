//
//  RadarSortOption.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 23.06.24.
//

import Foundation

enum SortOrder: String, Identifiable, CaseIterable {
    case ascending, descending

    var id: String { rawValue }

    var title: String {
        switch self {
        case .ascending: Strings.ascending
        case .descending: Strings.descending
        }
    }

    var icon: String {
        switch self {
        case .ascending: "arrow.up"
        case .descending: "arrow.down"
        }
    }
}

enum UserSortOption: String, CaseIterable, Identifiable {
    case age, name, distance

    var id: String { rawValue }

    var title: String {
        switch self {
        case .age: Strings.age
        case .name: Strings.name
        case .distance: Strings.distance
        }
    }

    // sorts the user depending on the active sort option
    func sort(
        users: [FireUser],
        rangeManager: RangeManager,
        userLocation: Location,
        order: SortOrder
    ) -> [FireUser] {
        let sortedUsers: [FireUser] = switch self {
        case .age:
            users.sorted {
                if let birthDate1 = $0.birthDate, let birthDate2 = $1.birthDate {
                    if birthDate1 != birthDate2 {
                        return birthDate1 > birthDate2
                    }
                }
                // Fallback to name if birthDate is equal or nil
                return ($0.name ?? "") < ($1.name ?? "")
            }
        case .name:
            users.sorted {
                if ($0.name ?? "") != ($1.name ?? "") {
                    return ($0.name ?? "") < ($1.name ?? "")
                }
                // Fallback to birthDate if name is equal
                return ($0.birthDate ?? Date()) > ($1.birthDate ?? Date())
            }
        case .distance:
            users.sorted {
                let dist1 = rangeManager.distance(from: userLocation, to: $0.location)
                let dist2 = rangeManager.distance(from: userLocation, to: $1.location)
                if dist1 != dist2 {
                    return dist1 < dist2
                }
                // Fallback to name if distance is equal
                return ($0.name ?? "") < ($1.name ?? "")
            }
        }
        return order == .ascending ? sortedUsers : sortedUsers.reversed()
    }
}
