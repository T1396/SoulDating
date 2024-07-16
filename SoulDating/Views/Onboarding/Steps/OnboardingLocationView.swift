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
    @StateObject private var keyboardVm = KeyboardViewModel()

    @Binding var progress: Double
    @Binding var stepIndex: Int
    @Binding var isOnboardingSuccessfully: Bool

    // MARK: body
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack(spacing: 16) {

                        if keyboardVm.keyboardHeight == 0 {
                            VStack(alignment: .leading) {

                                Image(systemName: "location.square.fill")
                                    .onboardingIconStyle()

                                Text("Your location")
                                    .appFont(size: 32, textWeight: .bold)
                                    .frame(maxWidth: .infinity, alignment: .center)

                                Text("We need a location to show you users in this area")
                                    .appFont(size: 14, textWeight: .light)

                            }
                            .animation(.easeInOut, value: keyboardVm.keyboardHeight)


                        }
                    }

                    Text("In which radius do you want to search?")
                        .appFont(size: 16, textWeight: .semibold)
                        .padding(.top, 12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(Int(viewModel.radius))km")
                        .appFont(size: 16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Slider(value: $viewModel.radius, in: 10...400, step: 1)

                    HStack {
                        LocationPickerView(
                            searchQuery: $viewModel.locationQuery,
                            suggestions: $viewModel.suggestions,
                            selectedSuggestion: $viewModel.selectedSuggestion,
                            onPlaceSelected: saveLocation
                        )
                    }
                    .padding(.bottom, keyboardVm.keyboardHeight)

                }
                Button(action: finishOnboarding) {
                    Text(Strings.finish)
                        .appButtonStyle(fullWidth: true)
                }
                .disabled(!viewModel.isValidLocation)
                .buttonStyle(PressedButtonStyle())
                .padding(.bottom)
            }
            .onAppear {
                withAnimation {
                    progress = 1.0
                }
            }
        }
        .padding(.horizontal)
    }

    // MARK: functions
    private func saveLocation(place: MKLocalSearchCompletion) {
        viewModel.togglePlace(completion: place)
    }

    private func finishOnboarding() {
        withAnimation {
            stepIndex += 1
            viewModel.updateUserDocument {
                isOnboardingSuccessfully = true
            }
        }
    }
}

#Preview {
    OnboardingLocationView(viewModel: OnboardingViewModel(), progress: .constant(1.0), stepIndex: .constant(5), isOnboardingSuccessfully: .constant(false))
        .environmentObject(UserViewModel())
}
