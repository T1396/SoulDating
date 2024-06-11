//
//  SwipeViewModel.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 11.06.24.
//

import Foundation
import Combine
import Firebase
import MapKit
import Contacts

class SwipeViewModel: ObservableObject {
    private let firebaseManager = FirebaseManager.shared
    
    @Published var swipeableUsers: [User] = []
    private var user: User?
    private var cancellables = Set<AnyCancellable>()
    
    
    func fetchUsersNearby() {
        guard let user else { return }
        let center: (lng: Double, lat: Double) = (user.location?.longitude ?? 50, user.location?.latitude ?? 0)
        let radius = user.location?.radius ?? 100
        let usersRef = firebaseManager.database.collection("users")
                
        // convert radius into lati-/longitude
        let rangeLat = radius / 111.0
        let rangeLon = radius / (111.320 * cos(center.lat * .pi / 180))

        // only fetch users in our radius
        let query = usersRef
            .whereField("location.longitude", isGreaterThanOrEqualTo: center.lng - rangeLon)
            .whereField("location.longitude", isLessThanOrEqualTo: center.lng + rangeLon)
            .whereField("location.latitude", isGreaterThanOrEqualTo: center.lat - rangeLat)
            .whereField("location.latitude", isLessThanOrEqualTo: center.lat + rangeLat)
            .whereField("id", isNotEqualTo: user.id)
        
        query.getDocuments { docSnapshot, error in
            if let error {
                print("Error fetching Users nearby", error.localizedDescription)
                return
            }
            
            guard let docSnapshot = docSnapshot else {
                // MARK: TODO - give response when there are no users nearby
                print("Error: No Documents found")
                return
            }

            self.swipeableUsers = docSnapshot.documents.compactMap { document in
                do {
                    let user = try document.data(as: User.self)
                    print("Successfully transformed \(user)")
                    return user
                } catch {
                    print("Could not decode user document id: \(document.documentID)", error.localizedDescription)
                    return nil
                }
            }
        }
    }
    
}

// MARK: user synchronization
extension SwipeViewModel {
    func configure(with userViewModel: UserViewModel) {
        self.user = userViewModel.user
        fetchUsersNearby()
        
        userViewModel.$user
            .compactMap { $0 }
            .sink { [weak self] newUser in
                self?.user = newUser
            }
            .store(in: &cancellables)
        
       
    }
}
