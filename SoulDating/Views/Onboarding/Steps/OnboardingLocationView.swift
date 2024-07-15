//
//  Onboarding.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 05.06.24.
//

import SwiftUI
import MapKit

class KeyboardResponsiveViewModel: ObservableObject {
    @Published var keyboardHeight: CGFloat = 0

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func keyboardWillShow(notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        DispatchQueue.main.async {
            self.keyboardHeight = keyboardSize.height
        }
    }

    @objc func keyboardWillHide() {
        DispatchQueue.main.async {
            self.keyboardHeight = 0
        }
    }
}

struct OnboardingLocationView: View {
    // MARK: properties
    @ObservedObject var viewModel: OnboardingViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @StateObject private var keyboardVm = KeyboardResponsiveViewModel()

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
                    .animation(.easeInOut, value: keyboardVm.keyboardHeight)
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
