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
            VStack(spacing: 16) {
                Text("Your location")
                    .appFont(size: 32, textWeight: .bold)
                
                Image(systemName: "location.square.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(.cyan)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Text("We need a location to show you users in this area")
                    .appFont(size: 14, textWeight: .light)
                
                
                Text("In which radius do you want to search?")
                    .appFont(size: 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
        
                HStack {
                    Text("\(Int(viewModel.radius))km")
                        .appFont(size: 16)

                    Slider(value: $viewModel.radius, in: 10...400, step: 1)
                }
                
                LocationPickerView(
                    searchQuery: $viewModel.locationQuery,
                    suggestions: $viewModel.suggestions,
                    selectedSuggestion: $viewModel.selectedSuggestion,
                    onPlaceSelected: saveLocation
                )
            
                    
                Button("Finish") {
                    viewModel.updateUserDocument()
                    navigate.toggle()
                }
                .appButtonStyle(fullWidth: true)
                .buttonStyle(PressedButtonStyle())
          
            }
            .navigationDestination(isPresented: $navigate) {
                NavigationView()
                    .environmentObject(userViewModel)
            }
            .navigationBarBackButtonHidden(true)
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
        .environmentObject(UserViewModel())
}
