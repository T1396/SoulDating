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
    
    @State private var navigate = false
    
    // MARK: body
    var body: some View {
        NavigationStack {
            VStack {
                Text("Dein Standort")
                    .titleStyle()
                Text("Wir benötigen den Standort um dir Nutzer in der Umgebung anzuzeigen")
                    .subTitleStyle()
                
                Text("Radius: \(Int(viewModel.radius))km")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Slider(value: $viewModel.radius, in: 50...400, step: 1)
                
                LocationPickerView(
                    searchQuery: $viewModel.locationQuery,
                    places: $viewModel.suggestions,
                    selectedPlace: $viewModel.selectedSuggestion,
                    onPlaceSelected: saveLocation
                )
                
                Button("Abschließen") {
                    viewModel.updateUserDocument()
                    navigate.toggle()
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.vertical)
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.location == nil)
            }
            .navigationDestination(isPresented: $navigate) {
                NavigationView()
                    .environmentObject(userViewModel)
            }
        }
        .padding(.horizontal)
    }
    
    // MARK: functions
    func saveLocation(place: MKLocalSearchCompletion) {
        viewModel.togglePlace(completion: place)
    }
}

#Preview {
    OnboardingLocationView(viewModel: OnboardingViewModel())
}
