//
//  LocationPickerView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 10.06.24.
//

import SwiftUI
import MapKit

struct LocationPickerView: View {
    @Binding var searchQuery: String
    @Binding var places: [MKMapItem]
    @Binding var selectedPlace: MKMapItem?
    var onPlaceSelected: (MKMapItem) -> Void
    
    var body: some View {
        VStack {
            TextField("Gib deinen ungefährten Standort an...", text: $searchQuery, onCommit: search)
                .textFieldStyle(AppTextFieldStyle())
                .textInputAutocapitalization(.never)
                .padding()
            
            List(places, id: \.self) { place in
                Button {
                    onPlaceSelected(place)
                } label: {
                    VStack(alignment: .leading) {
                        Text(place.name ?? "Unbekannter Ort")
                        Text(place.placemark.title ?? "")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                    }
                }
            }
        }
    }
    
    private func search() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchQuery
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response else {
                print("Error", error?.localizedDescription ?? "Unknown error")
                return
            }
            
            self.places = response.mapItems
        }
        
    }
}

#Preview {
    LocationPickerView(searchQuery: .constant("Hallo"), places: .constant([]), selectedPlace: .constant(nil), onPlaceSelected: {_ in })
}
