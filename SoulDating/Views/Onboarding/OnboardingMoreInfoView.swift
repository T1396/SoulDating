//
//  OnboardingGenderView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 09.06.24.
//

import SwiftUI

struct OnboardingMoreInfoView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    enum GenderPickerCase {
        case own, preferred
    }
    
    // MARK: computed properties
    var buttonBackground: Color {
        viewModel.userIsOldEnough ? .accentColor : .gray.opacity(0.7)
    }
    
    // MARK: body
    var body: some View {
        NavigationStack {
            VStack {
                
                Text("Tell us more about you")
                    .appFont(size: 40, textWeight: .bold)
                    .multilineTextAlignment(.center)
                Image(systemName: "shareplay")
                    .onboardingIconStyle()
                    .padding(.top, 24)
                
                Text("This information is used to suggest users to you and provide better suggestions for other users.")
                    .subTitleStyle()
                
                Spacer()
                
                genderPicker()
                preferredGenderPicker()
                birthDatePicker()
                //age range slider
                AgeRangeSliderView(userLowerbound: $viewModel.selectedMinAge, userUpperbound: $viewModel.selectedMaxAge)
                
                Spacer()
                Spacer()
                
                NavigationLink(destination: OnboardingPictureView(viewModel: viewModel)) {
                    Text("Continue")
                        .appButtonStyle()
                }
                .disabled(!viewModel.userIsOldEnough)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding()
        }
    }
    
    private func genderPicker() -> some View {
        HStack {
            Text("Choose your gender")
            Spacer()
            Picker("", selection: $viewModel.gender) {
                ForEach(Gender.allCases) { gender in
                    Text(gender.title).tag(gender)
                }
            }
        }
        .itemBackgroundStyle()
    }

    
    private func preferredGenderPicker() -> some View {
        HStack {
            Text("Choose your preferred gender(s)")
            Spacer()
            Picker("", selection: $viewModel.preferredGender) {
                ForEach(Gender.allCases) { gender in
                    Text(gender.title).tag(gender)
                }
            }
        }
        .itemBackgroundStyle()
    }
    
    @ViewBuilder
    private func birthDatePicker() -> some View {
        VStack {
            HStack {
                DatePicker("Tell us your date of birth",
                    selection: $viewModel.birthDate,
                    displayedComponents: .date
                )
                .datePickerStyle(.compact)
            }
            if !viewModel.userIsOldEnough {
                Text("You must be at least 16 years old...")
                    .font(.caption)
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .itemBackgroundStyle()
    }
    
}

#Preview {
    OnboardingMoreInfoView(viewModel: OnboardingViewModel())
}
