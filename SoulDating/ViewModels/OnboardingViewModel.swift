//
//  OnboardingViewModel.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 07.06.24.
//

import Foundation
import SwiftUI
import Combine
import Firebase
import MapKit

class OnboardingViewModel: BaseNSViewModel, MKLocalSearchCompleterDelegate {
    // MARK: properties
    private var completer: MKLocalSearchCompleter
    private let firebaseManager = FirebaseManager.shared
    private var searchCancellable: AnyCancellable?
    private let userService: UserService

    private var error: Error? // used to track error for a bug report

    @Published var birthDate = Date().subtractYears(18)
    @Published var gender: Gender = .randomGender()
    @Published var imageData: Data?
    @Published var preferredGender: Gender = .randomGender()
    @Published var selectedMinAge: Double = 19
    @Published var selectedMaxAge: Double = 60
    @Published var userDisplayName = ""

    @Published var location: Location = .init()
    @Published var locationQuery = ""
    @Published var radius: Double = 100
    @Published var selectedSuggestion: MKLocalSearchCompletion?
    @Published var suggestions: [MKLocalSearchCompletion] = []

    @Published var hasCriticalError = false
    @Published var userHasReportedAlready = false


    // MARK: init
    init(userService: UserService = .shared) {
        self.userService = userService
        completer = MKLocalSearchCompleter()
        super.init()
        completer.delegate = self
        completer.resultTypes = .address
        // react to changes in searchField
        searchCancellable = $locationQuery
            // reduces the amount of requests, if the query didnt changed for 0.5 seconds
            // while typing
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink { [weak self] query in
                self?.completer.queryFragment = query
            }
    }
    
    // MARK: computed properties
    var isValidUserName: Bool {
        userDisplayName.count > 3
    }

    var isValidLocation: Bool {
        location.latitude >= -90
    }

    var userIsOldEnough: Bool {
        let calendar = Calendar.current
        let now = Date()
        let ageComponents = calendar.dateComponents([.year], from: birthDate, to: now)
        let age = ageComponents.year ?? 0
        return age >= 18
    }
    
    
    // MARK: functions
    /// Updates the user document in firebase with the values chosen in the onboarding
    func updateUserDocument(completion: @escaping () -> Void) {
        guard let userId = firebaseManager.userId else { return }
        
        uploadImageToStorage(for: userId) { [weak self] result in
            switch result {
            case .success(let url):
                guard let self else { return }
                let user = getUpdatedUser(userId: userId, imageUrl: url.absoluteString)
                let newSortedImage = SortedImage(imageUrl: url.absoluteString, position: 0)
                // user details and images are saved into 2 different collections
                updateImagesAndUserDocument(user: user, newImage: newSortedImage) {
                    completion()
                }

            case .failure(let failure):
                print("Error while uploading user image", failure.localizedDescription)
                self?.hasCriticalError = true
            }
        }
    }

    /// executes a batch to upload the user document as well as the userImages document with the chosen picture url
    /// - Parameters:
    /// - user: the user to upload as user document
    /// - newImage: struct containing imageurl and position
    func updateImagesAndUserDocument(user: FireUser, newImage: SortedImage, completion: @escaping () -> Void) {
        let batch = firebaseManager.database.batch()
        let userRef = firebaseManager.database.collection("users").document(user.id)
        let userImagesRef = firebaseManager.database.collection("userImages").document(user.id)
        
        do {
            // update user document
            try batch.setData(from: user, forDocument: userRef)
            // insert image struct into userImages collection/ user document into "images" array
            let imageData = ["images": FieldValue.arrayUnion([newImage.toDict(pos: 0)])]
            batch.setData(imageData, forDocument: userImagesRef)
            
            batch.commit { error in
                if let error {
                    print("Error writing batch", error.localizedDescription)
                    self.createAlert(title: Strings.error, message: Strings.unexpectedErrorOccured, onAccept: self.sendBugReport, onAcceptText: Strings.sendReport)
                    self.hasCriticalError = true
                    return
                }
                // success
                self.resetValues()
                // update user in user service
                self.userService.user = user
                completion()
            }
        } catch {
            self.hasCriticalError = true
            print("error updating images and user document in firestore", error.localizedDescription)
        }
    }

    func sendBugReport() {
        firebaseManager.database.collection("bugReports").document()
            .setData([
                "errorMessage": error?.localizedDescription ?? "unknown error",
                "userId": firebaseManager.userId as Any,
                "timestamp": Date()
            ]) { error in
                
                if let error {
                    print("Failed to send a bug report", error.localizedDescription)
                    self.createAlert(title: Strings.error, message: Strings.unexpectedErrorMsg)
                } else {
                    self.createAlert(title: Strings.success, message: Strings.successfullyReportedBug)
                    self.userHasReportedAlready = true
                }
            }
    }

    
    /// Uploads the selected image into firebase storage and calls the closure when completed with the result
    func uploadImageToStorage(for userId: String, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let imageData else {
            completion(.failure(FirebaseError.nopicturechosen))
            return
        }
        let filename = UUID().uuidString + ".jpg"
        let userRef = firebaseManager.storage.reference().child("profileImages/\(userId)/\(filename)")
        
        userRef.putData(imageData, metadata: nil) { _, error in
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
    
    /// Resets all onboarding values to their initial state
    private func resetValues() {
        imageData = nil
        birthDate = .now.subtractYears(18)
        userDisplayName = ""
        location = .init()
        locationQuery = ""
        suggestions = []
        selectedSuggestion = nil
    }
}

// MARK: dictionaries functions
extension OnboardingViewModel {
    /// creates a user struct from all selected values in onboarding
    private func getUpdatedUser(userId: String, imageUrl: String) -> FireUser {
        location.radius = radius // update radius in location
        let preferences = Preferences(gender: [preferredGender], agePreferences: AgePreference(minAge: selectedMinAge, maxAge: selectedMaxAge))
        let user = FireUser(id: userId, name: userDisplayName, profileImageUrl: imageUrl, birthDate: birthDate, gender: gender, onboardingCompleted: true, location: location, preferences: preferences, registrationDate: .now)
        return user
    }
}

// MARK: MapKit functions
extension OnboardingViewModel {
    func togglePlace(completion: MKLocalSearchCompletion) {
        // uncheck suggestion
        if selectedSuggestion == completion {
            selectedSuggestion = nil
            return
        }
        
        // build MKLocalSearch and start search
        let searchRequest = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            guard let response = response, error == nil else {
                print("Error fetching MkLocalSearch: \(error?.localizedDescription ?? "unknown error")")
                return
            }
            
            if let item = response.mapItems.first {
                // save location with coordinates
                self.selectedSuggestion = completion
                self.location = Location(
                    latitude: item.placemark.coordinate.latitude,
                    longitude: item.placemark.coordinate.longitude,
                    name: item.name ?? "Unknown Area",
                    radius: self.radius
                )
            }
        }
    }
    
    
    // MARK: delegated functions for MKLocalSearchCompleterDelegate
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        DispatchQueue.main.async {
            self.suggestions = completer.results
        }
    }
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: any Error) {
        print("Error with MKLocalSearchCompleter", error.localizedDescription)
    }
}
