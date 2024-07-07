//
//  OnboardingGenderView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 09.06.24.
//

import SwiftUI

struct OnboardingMoreInfoView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @Binding var progress: Double
    @Binding var stepIndex: Int

    // MARK: computed properties
    var buttonBackground: Color {
        viewModel.userIsOldEnough ? .accentColor : .gray.opacity(0.7)
    }
    
    // MARK: body
    var body: some View {
        NavigationStack {
            VStack {

                Text(Strings.moreAboutYouTitle)
                    .appFont(size: 28, textWeight: .bold)
                    .multilineTextAlignment(.center)
                Image(systemName: "shareplay")
                    .onboardingIconStyle()
                    .padding(.top, 24)
                
                Text(Strings.moreInfoSubTitle)
                    .subTitleStyle()
                
                Spacer()
                
                genderPicker()
                preferredGenderPicker()
                birthDatePicker()
                // age range slider
                AgeRangeSliderView(userLowerbound: $viewModel.selectedMinAge, userUpperbound: $viewModel.selectedMaxAge)
                
                Spacer()
                Spacer()
                
                Button(action: goToNextPage) {
                    Text(Strings.continues)
                        .appButtonStyle(fullWidth: true)
                }    
                .disabled(!viewModel.userIsOldEnough)
            }
            .padding()

            .onAppear {
                withAnimation {
                    progress = 0.4
                }
            }
        }
    }
    
    private func genderPicker() -> some View {
        HStack {
            Text(Strings.chooseGender)
                .lineLimit(1)
                .appFont(size: 14, textWeight: .semibold)
            Spacer()
            Picker("", selection: $viewModel.gender) {
                ForEach(Gender.allCases) { gender in
                    Text(gender.title).tag(gender)
                        .appFont(size: 12, textWeight: .semibold)

                }
            }
        }
        .itemBackgroundStyle()
    }

    
    private func preferredGenderPicker() -> some View {
        HStack {
            Text(Strings.choosePrefGender)
                .appFont(size: 14, textWeight: .semibold)
                .lineLimit(1)
            Spacer()
            Picker("", selection: $viewModel.preferredGender) {
                ForEach(Gender.allCases) { gender in
                    Text(gender.title).tag(gender)
                        .appFont(size: 12, textWeight: .semibold)
                }
            }
        }
        .itemBackgroundStyle()
    }
    
    @ViewBuilder
    private func birthDatePicker() -> some View {
        VStack {
            HStack {
                DatePicker(Strings.tellBirthDate,
                    selection: $viewModel.birthDate,
                    displayedComponents: .date
                )
                .datePickerStyle(.compact)
                .appFont(size: 14, textWeight: .semibold)
            }
            if !viewModel.userIsOldEnough {
                Text(Strings.min16)
                    .appFont(size: 12)
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .itemBackgroundStyle()
    }
    
    // MARK: functions
    private func goToNextPage() {
        withAnimation {
            stepIndex += 1 // go to next onboarding page
        }
    }
    
}

#Preview {
    OnboardingMoreInfoView(viewModel: OnboardingViewModel(), progress: .constant(0.4), stepIndex: .constant(5))
}
