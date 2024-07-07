//
//  LocationViewModel.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 11.06.24.
//

import Foundation
import MapKit
import Combine

class LocationViewModel: BaseNSViewModel, MKLocalSearchCompleterDelegate {
    // MARK: properties
    private let firebaseManager = FirebaseManager.shared
    private let userService: UserService
    private var searchCancellable: AnyCancellable?
    private var completer: MKLocalSearchCompleter
    private var oldLocation: LocationPreference
    
    @Published var newLocation: LocationPreference?
    @Published var places: [MKMapItem] = []
    @Published var locationQuery = ""
    @Published var suggestions: [MKLocalSearchCompletion] = []
    @Published var selectedSuggestion: MKLocalSearchCompletion?
    @Published var radius: Double {
        didSet {
            newLocation?.radius = radius
        }
    }
    
    // MARK: computed properties
    var isValidNewLocation: Bool {
        oldLocation != newLocation && newLocation != nil && isPossibleLatitude
    }
    
    private var isPossibleLatitude: Bool {
        if let newLocation {
            return newLocation.latitude >= -90 && newLocation.latitude <= 90
        }
        return false
    }
    
    // MARK: init
    init(userService: UserService = .shared) {
        self.userService = userService
        let location = userService.user.location
        self.oldLocation = location
        // if latitude is lower than -90 its a base value meaning location must be initially set
        self.newLocation = location
        self.radius = location.radius
        self.completer = MKLocalSearchCompleter()
        super.init()
        // delegates all MKLocalSearch results to self (this viewModel instance)
        self.completer.delegate = self
        self.completer.resultTypes = .address
        
        // subscription on locationQuery
        self.searchCancellable = $locationQuery
        // delay search until no changes have been made for 0.5 seconds
            .debounce(for: 0.5, scheduler: RunLoop.main)
        // creates a subscription to locationQuery
            .sink { [weak self] query in // weak reference to prevent retain cycles
                // needed because sink has its own life-cycle and
                // searchCancellable holds the .sink active even when viewModel is destroyed
                // and a strong reference could prevent garbage collector from doing its work
                self?.completer.queryFragment = query
            }
    }
    
    // MARK: functions
    func updateLocation(completion: @escaping () -> Void) {
        guard let userId = firebaseManager.userId, let locationData = getLocationDict() else {
            completion()
            return
        }
        
        firebaseManager.database.collection("users").document(userId)
            .updateData(locationData) { error in
                if let error {
                    print("Failed to update Location for userId: \(userId)", error.localizedDescription)
                    self.createAlert(title: "Error", message: "Updating the location data failed. Please try again or contact support.")
                } else {
                    print("Location successfully updated")
                    if let newLocation = self.newLocation {
                        self.userService.user.location = newLocation
                    } else {
                        self.createAlert(title: "Error", message: "Something went wrong while updating your location...")
                    }
                }
                completion()
            }
    }
}

// MARK: MapKit functions
extension LocationViewModel {
    func togglePlace(searchSuggestion: MKLocalSearchCompletion) {
        // uncheck selected place
        if selectedSuggestion == searchSuggestion {
            selectedSuggestion = nil
            return
        }
        let searchRequest = MKLocalSearch.Request(completion: searchSuggestion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            guard let response = response, error == nil else {
                print("Fehler beim Abrufen der Details: \(error?.localizedDescription ?? "Unbekannter Fehler")")
                self.createAlert(title: "Error", message: "An error occured while saving your selection")
                return
            }
            
            if let item = response.mapItems.first {
                // save location with coordinates
                self.selectedSuggestion = searchSuggestion
                self.newLocation = LocationPreference(
                    latitude: item.placemark.coordinate.latitude,
                    longitude: item.placemark.coordinate.longitude,
                    name: item.name ?? "Unknown Area",
                    radius: self.radius
                )
            }
        }
    }
    
    
    // MARK: MKLocalSearchCompleterDelegate protocol methods
    // gets called when MKLocalSearchCompleterDelegate has new search suggestions
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        DispatchQueue.main.async {
            self.suggestions = completer.results
        }
    }
    // called when error while searching
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: any Error) {
        print("Error with MKLocalSearchCompleter", error.localizedDescription)
    }
}

// MARK: get dictionary to upload to firebase
extension LocationViewModel {
    func getLocationDict() -> [String: Any]? {
        guard let newLocation else { return nil }
        let locationData: [String: Any] = [
            "location.latitude": newLocation.latitude,
            "location.longitude": newLocation.longitude,
            "location.name": newLocation.name,
            "location.radius": newLocation.radius
        ]
        return locationData
    }
}
