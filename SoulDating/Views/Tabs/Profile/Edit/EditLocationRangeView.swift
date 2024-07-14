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
    @StateObject private var locationViewModel = EditLocationViewModel()
    @Environment(\.dismiss) var dismiss

    
    var heightLocale: Measurement<UnitLength> {
        Measurement(value: locationViewModel.radius, unit: UnitLength.kilometers)
    }

    private let formatStyle = Measurement<UnitLength>.FormatStyle(
        width: .wide,
        locale: .autoupdatingCurrent,
        usage: .general,
        numberFormatStyle: .number
    )

    // MARK: body
    var body: some View {
        VStack {
            Group {
                Text(Strings.updateLocationRadius)
                    .appFont(size: 32, textWeight: .bold)
                Text(Strings.willUpdateSuggestions)
                    .appFont(size: 16, textWeight: .thin)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Text(heightLocale, format: formatStyle)
                .frame(maxWidth: .infinity, alignment: .leading)
            Slider(value: $locationViewModel.radius, in: 10...400, step: 1)


            LocationPickerView(
                searchQuery: $locationViewModel.locationQuery,
                suggestions: $locationViewModel.suggestions,
                selectedSuggestion: $locationViewModel.selectedSuggestion,
                onPlaceSelected: togglePlace
            )

            HStack {
                Button(Strings.cancel, action: { dismiss() })
                Spacer()
                Button(action: updateLocation) {
                    Text(Strings.update)
                        .appButtonStyle()
                }
                .disabled(!locationViewModel.isValidNewLocation)
            }
            .padding(.vertical)

        }
        .alert(locationViewModel.alertTitle, isPresented: $locationViewModel.showAlert, actions: {
            Button("OK", role: .destructive, action: { locationViewModel.showAlert = false })
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
    EditLocationRangeView()        
        .environment(\.locale, Locale(identifier: "de-DE"))

}
