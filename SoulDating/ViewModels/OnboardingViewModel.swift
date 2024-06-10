//
//  OnboardingViewModel.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 07.06.24.
//

import Foundation
import Combine

class OnboardingViewModel: ObservableObject {
    private let firebaseManager = FirebaseManager.shared
    
    
    @Published var birthDate = Date()
    @Published var location: LocationPreference?
    @Published var gender: Gender = .randomGender()
    @Published var preferredGender: Gender = .randomGender()
    @Published var userDisplayName = ""
    
    var searchCancellable: AnyCancellable?
    @Published var locationQuery = ""
    
    init() {
        searchCancellable = $locationQuery
            .removeDuplicates()
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink(receiveValue: { [weak self] query in
                self?.searchLocation(query: query)
            })
    }

    var isValidUserName: Bool {
        userDisplayName.count > 3
    }
    
    var userIsOldEnough: Bool {
        let calendar = Calendar.current
        let now = Date()
        let ageComponents = calendar.dateComponents([.year], from: birthDate, to: now)
        let age = ageComponents.year ?? 0
        return age >= 16
    }
    
    func searchLocation(query: String) {
        
    }
    
    func updateUserDocument() {
        guard let userId = firebaseManager.userId else { return }
        let db = firebaseManager.database
        let userRef = db.collection("users").document(userId)
        
        // Die neuen Werte für userName und location
        let updateFields: [String: Any] = [
            "userName": userDisplayName,
            "location": [
                "latitude": location?.latitude,
                "longitude": location?.longitude,
                "name": location?.name,
                "radius": location?.radius
            ],
            "gender": gender.rawValue,
            "preferredGender": preferredGender.rawValue,
            "onboardingCompleted" : true
        ]
        
        userRef.updateData(updateFields) { error in
            if let error = error {
                print("Fehler beim Aktualisieren des Dokuments: \(error.localizedDescription)")
            } else {
                print("Dokument erfolgreich aktualisiert.")
            }
        }
    }
}
