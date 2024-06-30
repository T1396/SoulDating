//
//  EditLocationView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 10.06.24.
//

import SwiftUI
import MapKit

struct EditLocationRangeView: View {
    // MARK: properties
    @StateObject private var locationViewModel: LocationViewModel
    @Environment(\.dismiss) var dismiss
    
    // MARK: init
    init(location: LocationPreference, user: User) {
        self._locationViewModel = StateObject(wrappedValue: LocationViewModel(location: location, user: user))
    }
    
    // MARK: body
    var body: some View {
        VStack {
            Text("Update your location & radius")
                .titleStyle()
            Text("This will change your user suggestions")
                .subTitleStyle()
            
            Text("Radius: \(Int(locationViewModel.radius))km")
                .frame(maxWidth: .infinity, alignment: .leading)
            Slider(value: $locationViewModel.radius, in: 10...400, step: 1)
            
            
            LocationPickerView(
                searchQuery: $locationViewModel.locationQuery,
                suggestions: $locationViewModel.suggestions,
                selectedSuggestion: $locationViewModel.selectedSuggestion,
                onPlaceSelected: togglePlace
            )
            
            Button(action: updateLocation) {
                Text("Update")
                    .appButtonStyle(fullWidth: true)
            }
            .disabled(!locationViewModel.isValidNewLocation)
            .padding(.vertical)
    
        }
        .alert(locationViewModel.alertTitle, isPresented: $locationViewModel.showAlert, actions: {
            Button("Ok", role: .destructive, action: { locationViewModel.showAlert = false })
        }, message: {
            Text(locationViewModel.alertMessage)
        })
        .padding()
        
    }
    
    // MARK: functions
    private func updateLocation() {
        locationViewModel.updateLocation {
            dismiss()
        }
    }
    
    private func togglePlace(place: MKLocalSearchCompletion) {
        locationViewModel.togglePlace(searchSuggestion: place)
    }
}

#Preview {
    EditLocationRangeView(location: LocationPreference(latitude: 51.1023, longitude: 10.1238, name: "Haus nebenan", radius: 100), user: User(id: "1", name: "Klaus"))
}
