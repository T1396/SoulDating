//
//  Onboarding.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 05.06.24.
//

import SwiftUI
import MapKit

struct OnboardingLocationView: View {
    // MARK: properties
    @ObservedObject var viewModel: OnboardingViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    
    @State private var searchQuery = ""
    @State private var places = [MKMapItem]()
    @State private var place: MKMapItem? = nil
    @State private var navigate = false
    @State private var radius: Double = 100 // in km
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Dein Standort")
                    .titleStyle()
                Text("Wir benötigen den Standort um dir Nutzer in der Umgebung anzuzeigen")
                    .subTitleStyle()
                
                LocationPickerView(searchQuery: $searchQuery, places: $places, selectedPlace: $place) { place in
                    saveLocation(place: place)
                }
                
                Slider(value: $radius, in: 50...400, step: 20)
                Text("Radius: \(Int(radius))m")
                    .padding()
                
                Button("Abschließen") {
                    viewModel.updateUserDocument()
                    navigate.toggle()
                }
                

            }
            .navigationDestination(isPresented: $navigate) {
                NavigationView()
                    .environmentObject(userViewModel)
            }
        }
    }
    
    // MARK: functions
    private func locationList() -> some View {
        List(places, id: \.self) { place in
            Button {
                saveLocation(place: place)
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
    
    private func search() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchQuery
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else {
                print("Error", error?.localizedDescription ?? "Unbekannter Fehler")
                return
            }
            
            self.places = response.mapItems
        }
    }
    
    func saveLocation(place: MKMapItem) {
        viewModel.location = LocationPreference(latitude: place.placemark.coordinate.latitude, longitude: place.placemark.coordinate.longitude, name: place.name ?? "Unknown place", radius: radius)
        self.place = place
    }
}

#Preview {
    OnboardingLocationView(viewModel: OnboardingViewModel())
}
