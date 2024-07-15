//
//  RadarViewModel.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 19.06.24.
//

import Foundation
import SwiftUI

class RadarViewModel: BaseAlertViewModel {
    // MARK: properties
    private let firebaseManager = FirebaseManager.shared
    private let rangeManager = RangeManager.shared
    private let userService: UserService
    private var user: FireUser

    @Published var allUsersInRange: [FireUser] = []
    @Published var activeSort: UserSortOption = .distance
    @Published var sortOrder: SortOrder = .ascending
    @Published var activeFilterOptions: [RadarFilter: Set<String>] = [:]

    // MARK: init
    init(userService: UserService = .shared) {
        self.userService = userService
        self.user = userService.user
        super.init()
        searchUsersInRange(ownLocation: user.location)
    }

    // MARK: computed properties
    var sortedUsers: [FireUser] {
        // enum holds sort function
        activeSort.sort(users: allUsersInRange, rangeManager: rangeManager, userLocation: user.location, order: sortOrder)
    }

    // MARK: functions
    private func searchUsersInRange(ownLocation: Location) {
        guard let userId = firebaseManager.userId else { return }
        
        let usersRef = firebaseManager.database.collection("users")
        let query = rangeManager.buildRangeQuery(collectionRef: usersRef, excluding: userId, location: user.location)
            .whereField("isHidden", isEqualTo: false)

        query.getDocuments { docSnapshot, error in
            if let error {
                print("RadarVM Error fetching all users in range", error.localizedDescription)
                self.createAlert(title: Strings.error, message: Strings.radarFetchError)
                return
            }

            var users = docSnapshot?.documents.compactMap { doc in
                try? doc.data(as: FireUser.self)
            } ?? []
            // filter out not matching genders and ages
            users = self.filterOutNotPreferredUsers(users)
            users = self.filterRange(users)
            self.allUsersInRange = users
        }
    }

    func distance(to targetLocation: Location) -> String? {
        rangeManager.distanceString(from: user.location, to: targetLocation)
    }
    
    // filters out users that are not in range, ( range query gives square root results so it need further filtering )
    func filterRange(_ users: [FireUser]) -> [FireUser] {
        users.filter {
            let isInDistance = rangeManager.checkForDistance($0.location, self.user.location)
            return isInDistance
        }
    }

    /// accepts a list of users and filters not desired genders or ages out and returns the filtered list
    func filterOutNotPreferredUsers(_ users: [FireUser]) -> [FireUser] {
        let preferredGenders = Set(self.user.preferences.gender ?? Gender.allCases)
        var filtered = users.filter { user in
            preferredGenders.contains(where: { $0.rawValue == user.gender?.rawValue })
        }

        let minAge = Int(self.user.preferences.agePreferences?.minAge ?? 18)
        let maxAge = Int(self.user.preferences.agePreferences?.maxAge ?? 100)

        filtered = filtered.filter { user in
            let userAge = user.age ?? 18
            return userAge >= minAge && userAge <= maxAge
        }
        return filtered
    }

    // gets called when reentered the view to detect changes and refetch when neccessary
    func updateUserAndRefetchIfNeeded() {
        let oldUser = self.user
        self.user = userService.user
        if user.hasRelevantDataChangesToRefetch(from: oldUser) {
            searchUsersInRange(ownLocation: user.location)
        }
    }
}

// MARK: filter users and toggle filter
extension RadarViewModel {
    var filteredSortedUsers: [FireUser] {
        let results = sortedUsers
        if activeFilterOptions.isEmpty {
            return results
        } else {
            return getFilteredUserList(user: results)
        }
    }

    private func getFilteredUserList(user: [FireUser]) -> [FireUser] {
        var results = user
        activeFilterOptions.forEach { filter, rawValues in
            switch filter {
            case .education:
                results = results.filter { user in
                    rawValues.contains(user.general.education.rawValue)
                }
            case .interests:
                results = results.filter { user in
                    let userInterests = Set(user.general.interests?.map { $0.rawValue } ?? [])
                    return rawValues.isSubset(of: userInterests)
                }
            case .smoker:
                results = results.filter { user in
                    rawValues.contains(user.general.smokingStatus.rawValue)
                }
            case .bodyType:
                results = results.filter { user in 
                    rawValues.contains(user.look.bodyType.rawValue)
                }
            }
        }
        return results
    }

    /// toggles a filter option like only users with gaming interests
    /// - Parameter filter: the selected filter which has different options like interests, education etc
    /// - Parameter optionRawValue: the selected option rawvalue, e.g. gaming from interests, to filter only ppl with gaming interests
    func toggleFilterOption(_ filter: RadarFilter, optionRawValue: String) {
        print(filter)
        print(optionRawValue)
        if activeFilterOptions[filter]?.contains(optionRawValue) ?? false {
            activeFilterOptions[filter]?.remove(optionRawValue)
            // remove the key for the filter of the dictionary if it has no values anymore
            if activeFilterOptions[filter]?.isEmpty ?? true {
                activeFilterOptions.removeValue(forKey: filter)
            }
        } else {
            // create dictionary with filter as key and insert the first option rawvalue
            activeFilterOptions[filter, default: Set()].insert(optionRawValue)
        }
    }
    
    func isOptionSelected(_ filter: RadarFilter, option: String) -> Bool {
        activeFilterOptions[filter]?.contains(option) ?? false
    }
}
