//
//  RadarViewModel.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 19.06.24.
//

import Foundation
import SwiftUI

let mockUsers: [User] = [
    User(id: "user1", name: "Alice", profileImageUrl: "https://firebasestorage.googleapis.com:443/v0/b/souldating-b6486.appspot.com/o/profileImages%2FFW4oOlh92QUyzxUd8reUoYVSBfn2%2F8E55C58C-C011-4A27-B64F-78FDF5921167.jpg?alt=media&token=ad2b148f-3685-40e3-a28a-fbbe7ad2495e", birthDate: Date(timeIntervalSinceNow: -86400 * 365 * 25), gender: .female, onboardingCompleted: true, location: LocationPreference(latitude: 40.7128, longitude: -74.0060, name: "Central New York", radius: 5)),
    User(id: "user2", name: "Bob", profileImageUrl: "https://example.com/bob.jpg", birthDate: Date(timeIntervalSinceNow: -86400 * 365 * 30), gender: .male, onboardingCompleted: true, location: LocationPreference(latitude: 40.7158, longitude: -74.0150, name: "Lower Manhattan", radius: 5)),
    User(id: "user3", name: "Charlie", profileImageUrl: "https://example.com/charlie.jpg", birthDate: Date(timeIntervalSinceNow: -86400 * 365 * 28), gender: .divers, onboardingCompleted: true, location: LocationPreference(latitude: 40.7580, longitude: -73.9855, name: "Midtown Manhattan", radius: 5)),
    User(id: "user4", name: "David", profileImageUrl: "https://firebasestorage.googleapis.com:443/v0/b/souldating-b6486.appspot.com/o/profileImages%2FY2PNqReH9YQsKIMnsxnwDZ23L6m1%2F93E6AAB6-631B-4737-863E-B9228076E66F.jpg?alt=media&token=a62885fc-2f79-4b6c-aef7-601a8c86ba3f", birthDate: Date(timeIntervalSinceNow: -86400 * 365 * 27), gender: .male, onboardingCompleted: true, location: LocationPreference(latitude: 40.730610, longitude: -73.935242, name: "East Village", radius: 5)),
    User(id: "user5", name: "Ella", profileImageUrl: "https://firebasestorage.googleapis.com:443/v0/b/souldating-b6486.appspot.com/o/profileImages%2FY2PNqReH9YQsKIMnsxnwDZ23L6m1%2F93E6AAB6-631B-4737-863E-B9228076E66F.jpg?alt=media&token=a62885fc-2f79-4b6c-aef7-601a8c86ba3f", birthDate: Date(timeIntervalSinceNow: -86400 * 365 * 22), gender: .female, onboardingCompleted: true, location: LocationPreference(latitude: 40.748817, longitude: -73.985428, name: "Near Empire State", radius: 5)),
    User(id: "user6", name: "Frank", profileImageUrl: "https://example.com/frank.jpg", birthDate: Date(timeIntervalSinceNow: -86400 * 365 * 35), gender: .male, onboardingCompleted: true, location: LocationPreference(latitude: 40.712776, longitude: -74.005974, name: "Financial District", radius: 5)),
    User(id: "user7", name: "Grace", profileImageUrl: "https://example.com/grace.jpg", birthDate: Date(timeIntervalSinceNow: -86400 * 365 * 29), gender: .female, onboardingCompleted: true, location: LocationPreference(latitude: 40.785091, longitude: -73.968285, name: "Upper East Side", radius: 5)),
    User(id: "user8", name: "Henry",profileImageUrl: "https://firebasestorage.googleapis.com:443/v0/b/souldating-b6486.appspot.com/o/profileImages%2FFW4oOlh92QUyzxUd8reUoYVSBfn2%2F8E55C58C-C011-4A27-B64F-78FDF5921167.jpg?alt=media&token=ad2b148f-3685-40e3-a28a-fbbe7ad2495e", birthDate: Date(timeIntervalSinceNow: -86400 * 365 * 20), gender: .male, onboardingCompleted: true, general: UserGeneral(interests: [.animals, .art, .astrology]), location: LocationPreference(latitude: 40.829643, longitude: -73.926175, name: "Bronx", radius: 5))
]

protocol RangeCalculating: ObservableObject {
    var rangeManager: RangeManager { get }
    func distance(to targetLocation: LocationPreference) -> String?
}

class MockRadarViewModel: RangeCalculating {
    @Published var allUsersInRange: [User] = []
    @Published var filteredUsers: [User] = []
    @Published var noUsersAvailable = false
    
    @Published var activeSortOption: RadarSortOption = .distance {
        didSet {
            applySorting()
        }
    }
    @Published var activeFilterOptions: [RadarFilter: Set<String>] = [:]
    
    internal let rangeManager = RangeManager()

    private var user: User
    
    init(user: User) {
        self.user = user
        loadMockUsers()
    }
    
    func applyFilters() {
        var results = allUsersInRange
        print(results)
        if activeFilterOptions.isEmpty {
            filteredUsers = results
        } else {
            activeFilterOptions.forEach { filter, values in
                switch filter {
                case .education:
                    results = results.filter { user in values.contains(user.general.education?.rawValue ?? "") }
                case .interests:
                    results = results.filter { user in
                        let userInterests = Set(user.general.interests?.map { $0.rawValue } ?? [])
                        return values.isSubset(of: userInterests)
                    }
                case .smoker:
                    results = results.filter { user in values.contains(user.general.smokingStatus?.rawValue ?? "") }
                case .bodyType:
                    results = results.filter { user in values.contains(user.look.bodyType?.rawValue ?? "") }
                }
            }
            filteredUsers = results
        }
        print(results)
        noUsersAvailable = filteredUsers.isEmpty
        applySorting()
    }
    
    func applySorting() {
        withAnimation {
            switch activeSortOption {
            case .age:
                filteredUsers.sort { $0.birthDate ?? Date() > $1.birthDate ?? Date() }
            case .name:
                filteredUsers.sort { ($0.name ?? "") < ($1.name ?? "") }
            case .distance:
                filteredUsers.sort {
                    let distance1 = rangeManager.distance(from: user.location, to: $0.location)
                    let distance2 = rangeManager.distance(from: user.location, to: $1.location)
                    return distance1 < distance2
                }
            }
        }
    }
    
    
    private func loadMockUsers() {
        self.allUsersInRange = mockUsers
        self.filteredUsers = mockUsers
        sortUsers(by: .distance)
        self.noUsersAvailable = mockUsers.isEmpty
    }
    
    func distance(to targetLocation: LocationPreference) -> String? {
        rangeManager.distanceString(from: user.location, to: targetLocation)
    }
    
    func toggleFilterOption(_ filter: RadarFilter, option: String) {
        if activeFilterOptions[filter]?.contains(option) ?? false {
            activeFilterOptions[filter]?.remove(option)
            if activeFilterOptions[filter]?.isEmpty ?? true {
                activeFilterOptions.removeValue(forKey: filter)
            }
        } else {
            activeFilterOptions[filter, default: Set()].insert(option)
        }
        applyFilters()
    }
    
    func isOptionSelected(_ filter: RadarFilter, option: String) -> Bool {
        return activeFilterOptions[filter]?.contains(option) ?? false
    }
    
    func isSortSelected(_ option: RadarSortOption) -> Bool {
        activeSortOption == option
    }
    
    func filterUsers(filterOption: RadarFilter, rawValues: Set<String>) {
        print(filterOption)
        print(rawValues)
        switch filterOption {
        case .education:
            filteredUsers = allUsersInRange.filter { rawValues.contains($0.general.education?.rawValue ?? "") }
        case .interests:
            filteredUsers = allUsersInRange.filter { user in
                let userInterests = Set(user.general.interests?.map { $0.rawValue } ?? [])
                print(userInterests)
                return rawValues.isSubset(of: userInterests)
            }
        case .smoker:
            filteredUsers = filteredUsers.filter { rawValues.contains($0.general.smokingStatus?.rawValue ?? "") }
        case .bodyType:
            filteredUsers = filteredUsers.filter { rawValues.contains($0.look.bodyType?.rawValue ?? "") }
        }
        
        if filteredUsers.isEmpty && rawValues.isEmpty {
            filteredUsers = allUsersInRange
        }
    }
    
    func setSortOption(_ option: RadarSortOption) {
        self.activeSortOption = option
    }
    
    private func sortUsers(by option: RadarSortOption) {
        withAnimation {
            switch option {
            case .age:
                filteredUsers.sort { $0.birthDate ?? Date() > $1.birthDate ?? Date() }
            case .name:
                filteredUsers.sort { ($0.name ?? "") < ($1.name ?? "") }
                
            case .distance:
                filteredUsers.sort {
                    let distance1 = rangeManager.distance(from: user.location, to: $0.location)
                    let distance2 = rangeManager.distance(from: user.location, to: $1.location)
                    return distance1 < distance2
                }
            }
        }
    }
    
    
}


class RadarViewModel: BaseAlertViewModel, RangeCalculating {
    func distance(to targetLocation: LocationPreference) -> String? {
        ""
    }
    
    private let firebaseManager = FirebaseManager.shared
    internal let rangeManager = RangeManager()
    
    @Published var allUsersInRange: [User] = []
    @Published var noUsersAvailable = false
    private var user: User
    
    init(user: User) {
        self.user = user
        super.init()
        searchUsersInRange(ownLocation: user.location)
    }
    
    func searchUsersInRange(ownLocation: LocationPreference) {
        guard let userId = firebaseManager.userId else { return }
        
        let usersRef = firebaseManager.database.collection("users")
        let query = rangeManager.buildRangeQuery(collectionRef: usersRef, excluding: [userId], location: user.location, printValues: true)
        
        query.getDocuments { docSnapshot, error in
            if let error {
                print("RadarVM Error fetching all users in range", error.localizedDescription)
                self.createAlert(title: "Error", message: "Failed to lookup for users in your range")
                return
            }
            
            guard let docSnapshot else { return }
            
            if docSnapshot.documents.isEmpty {
                self.noUsersAvailable = true
            } else {
                
                let users = docSnapshot.documents.compactMap { document -> User? in
                    do {
                        let user = try document.data(as: User.self)
                        return self.rangeManager.checkForDistance(user.location, ownLocation) ? user : nil
                    } catch {
                        print("decoding error (radarviewmodel)", error.localizedDescription)
                        return nil
                    }
                }
                
                self.noUsersAvailable = users.isEmpty
                self.allUsersInRange = users
            }
        }
    }
}
