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
    @Binding var places: [MKLocalSearchCompletion]
    @Binding var selectedPlace: MKLocalSearchCompletion?

    var onPlaceSelected: (MKLocalSearchCompletion) -> Void
    
    var body: some View {
        VStack {
            TextField("Gib deinen ungefährten Standort an...", text: $searchQuery)
                .textFieldStyle(AppTextFieldStyle())
                .textInputAutocapitalization(.never)
            
            ScrollView {
                ForEach(places, id: \.self) { place in
                    Button {
                        onPlaceSelected(place)
                    } label: {
                        LocationRow(place: place, selectedPlace: $selectedPlace)
                    }
                }
            }
        }
    }
}

struct LocationRow: View {
    let place: MKLocalSearchCompletion
    @Binding var selectedPlace: MKLocalSearchCompletion?
    
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(place.title)
                Text(place.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
            Spacer()
            if let selectedPlace, selectedPlace == place {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
            }
        }
        .padding()
        .background(colorScheme == .light ? .gray.opacity(0.1) : .gray.opacity(0.3), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

#Preview {
    LocationPickerView(searchQuery: .constant(""), places: .constant([]),selectedPlace: .constant(MKLocalSearchCompletion()) ,onPlaceSelected: { _ in })
}
