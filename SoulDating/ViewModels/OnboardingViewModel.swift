//
//  OnboardingViewModel.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 07.06.24.
//

import Foundation
import SwiftUI
import Combine
import MapKit

class OnboardingViewModel: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    // MARK: properties
    private let firebaseManager = FirebaseManager.shared
    
    @Published var imageData: Data?
    @Published var birthDate = Date()
    @Published var gender: Gender = .randomGender()
    @Published var preferredGender: Gender = .randomGender()
    @Published var userDisplayName = ""
    @Published var selectedMinAge: Double = 19
    @Published var selectedMaxAge: Double = 60
    
    //Location elements
    @Published var location: LocationPreference?
    @Published var radius: Double = 100
    @Published var places: [MKMapItem] = []
    var searchCancellable: AnyCancellable?
    private var completer: MKLocalSearchCompleter
    @Published var locationQuery = ""
    @Published var suggestions: [MKLocalSearchCompletion] = []
    @Published var selectedSuggestion: MKLocalSearchCompletion?
    
    // MARK: init
    override init() {
        completer = MKLocalSearchCompleter()
        super.init()
        completer.delegate = self
        completer.resultTypes = .address
        
        // react to changes in searchField
        searchCancellable = $locationQuery
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink { [weak self] query in
                self?.completer.queryFragment = query
            }
    }

    // MARK: computed properties
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
    
    // MARK: functions
    func updateUserDocument() {
        guard let userId = firebaseManager.userId else { return }
        
        uploadImageToStorage(for: userId) { [weak self] result in
            switch result {
            case .success(let url):
                guard let self else { return }
                let db = self.firebaseManager.database
                let userRef = db.collection("users").document(userId)
                var updatedDict = getUpdatedValueDictionary()
                
                // add image url to dictionary
                updatedDict["profileImageUrl"] = url.absoluteString
                
                userRef.updateData(updatedDict) { error in
                    if let error = error {
                        print("Fehler beim Aktualisieren des Dokuments: \(error.localizedDescription)")
                    } else {
                        print("Dokument erfolgreich aktualisiert.")
                        NotificationCenter.default.post(name: .userDocumentUpdated, object: nil)
                    }
                }
            case .failure(let failure):
                print("Error while uploading user image", failure.localizedDescription)
            }
        }
        
       
    }
    
    func uploadImageToStorage(for userId: String, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let imageData else {
            completion(.failure(FirebaseError.nopicturechosen))
            return
        }
        let filename = UUID().uuidString + ".jpg"
        let userRef = firebaseManager.storage.reference().child("profileImages/\(userId)/\(filename)")
        userRef.putData(imageData, metadata: nil) { metadata, error in
            if let error {
                completion(.failure(error))
                return
            }
            
            userRef.downloadURL { url, error in
                if let url {
                    completion(.success(url))
                } else {
                    completion(.failure(error ?? FirebaseError.downloadUrlFailure))
                }
            }
        }
    }
}

extension Notification.Name {
    static let userDocumentUpdated = Notification.Name("userDocumentUpdated")
}

// MARK: dictionaries functions
extension OnboardingViewModel {
    private func getUpdatedValueDictionary() -> [String: Any] {
        let dict: [String: Any] = [
            "userName": userDisplayName,
            "location": location?.toDictionary(),
            "minAge": selectedMinAge,
            "maxAge": selectedMaxAge,
            "gender": gender.rawValue,
            "preferredGender": preferredGender.rawValue,
            "onboardingCompleted" : true
        ]
        return dict
    }
}

extension LocationPreference {
    func toDictionary() -> [String: Any] {
        return [
            "latitude": latitude,
            "longitude": longitude,
            "name": name,
            "radius": radius
        ]
    }
}

// MARK: MapKit functions
extension OnboardingViewModel {
    func togglePlace(completion: MKLocalSearchCompletion) {
        if selectedSuggestion == completion {
            selectedSuggestion = nil
            return
        }
        
        let searchRequest = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            guard let response = response, error == nil else {
                print("Fehler beim Abrufen der Details: \(error?.localizedDescription ?? "Unbekannter Fehler")")
                return
            }

            if let item = response.mapItems.first {
                // save location with coordinates
                self.selectedSuggestion = completion
                self.location = LocationPreference(
                    latitude: item.placemark.coordinate.latitude,
                    longitude: item.placemark.coordinate.longitude,
                    name: item.name ?? "Unknown Area",
                    radius: self.radius
                )
            }
        }
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        DispatchQueue.main.async {
            self.suggestions = completer.results
        }
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: any Error) {
        print("Error with MKLocalSearchCompleter", error.localizedDescription)
    }
}
