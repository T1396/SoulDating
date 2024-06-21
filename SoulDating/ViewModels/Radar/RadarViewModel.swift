//
//  RadarViewModel.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 19.06.24.
//

import Foundation

class RadarViewModel: BaseAlertViewModel {
    private let firebaseManager = FirebaseManager.shared
    private let rangeManager = RangeManager()
    
    @Published var allUsersInRange: [User] = []
    @Published var noUsersAvailable = false
    private var user: User
    
    init(user: User) {
        self.user = user
        super.init()
        if let location = user.location {
            searchUsersInRange(ownLocation: location)
        }
    }
    
    func searchUsersInRange(ownLocation: LocationPreference) {
        guard let userId = firebaseManager.userId, let location = user.location else { return }
        
        let usersRef = firebaseManager.database.collection("users")
        let query = rangeManager.buildRangeQuery(collectionRef: usersRef, excluding: [userId], location: location, printValues: true)
        
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
                        guard let userLocation = user.location else { return nil }
                        return self.rangeManager.checkForDistance(userLocation, ownLocation) ? user : nil
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
