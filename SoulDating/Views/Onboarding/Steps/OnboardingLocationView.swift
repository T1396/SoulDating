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
    @Binding var progress: Double
    @Binding var stepIndex: Int
    @Binding var isOnboardingSuccessfully: Bool
    @State private var keyboardHeight: CGFloat = 0

    @State private var navigate = false
    
    // MARK: body
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack(spacing: 16) {

                        if keyboardHeight == 0 {
                            Text("Your location")
                                .appFont(size: 32, textWeight: .bold)

                            Image(systemName: "location.square.fill")
                                .onboardingIconStyle()

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
                        }

                        LocationPickerView(
                            searchQuery: $viewModel.locationQuery,
                            suggestions: $viewModel.suggestions,
                            selectedSuggestion: $viewModel.selectedSuggestion,
                            onPlaceSelected: saveLocation
                        )


                    }
                    .padding(.bottom, keyboardHeight)
                    


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
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
                    guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
                    keyboardHeight = keyboardSize.height
                    print(keyboardHeight)
                }

                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                    keyboardHeight = 0
                }

                withAnimation {
                    progress = 1.0
                }
            }
            .onDisappear {
                NotificationCenter.default.removeObserver(self)
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
                print("updated user document")
                isOnboardingSuccessfully = true
            }
        }
    }
}

#Preview {
    OnboardingLocationView(viewModel: OnboardingViewModel(), progress: .constant(1.0), stepIndex: .constant(5), isOnboardingSuccessfully: .constant(false))
        .environmentObject(UserViewModel())
}
