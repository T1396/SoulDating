//
//  OnboardingGenderView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 09.06.24.
//

import SwiftUI

struct OnboardingGenderView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    // MARK: computed properties
    var buttonBackground: Color {
        viewModel.userIsOldEnough ? .accentColor : .gray.opacity(0.7)
    }
    
    // MARK: body
    var body: some View {
        NavigationStack {
            VStack {
                Text("Erzähl uns etwas mehr von dir")
                    .titleStyle()
                Text("Diese Informationen dienen dazu dir Nutzer vorzuschlagen und für andere Nutzer bessere vorschläge zu liefern.")
                    .subTitleStyle()
                
                Spacer()
                
                ownGenderPicker()
                preferredGenderPicker()
                birthDatePicker()
                RangeSliderView(userLowerbound: $viewModel.selectedMinAge, userUpperbound: $viewModel.selectedMaxAge)
                
                Spacer()
                Spacer()
                
                NavigationLink(destination: OnboardingPictureView(viewModel: viewModel)) {
                    Text("Weiter")
                        .textButtonStyle(color: buttonBackground)
                }
                .disabled(!viewModel.userIsOldEnough)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding()
        }
    }
    
    @ViewBuilder
    private func ownGenderPicker() -> some View {
        HStack {
            Text("Wähle dein Geschlecht")
            Spacer()
            Picker("", selection: $viewModel.gender) {
                ForEach(Gender.allCases) { gender in
                    Text(gender.title).tag(gender)
                }
            }
        }
        .itemBackgroundStyle()
    }
    
    @ViewBuilder
    private func preferredGenderPicker() -> some View {
        HStack {
            Text("Nach was suchst du?")
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
                DatePicker("Wann wurdest du geboren?", selection: $viewModel.birthDate, displayedComponents: .date)
                    .datePickerStyle(.compact)
            }
            if !viewModel.userIsOldEnough {
                Text("Du musst mindestens 16 Jahre alt sein.")
                    .font(.caption)
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .itemBackgroundStyle()
    }
    
}

#Preview {
    OnboardingGenderView(viewModel: OnboardingViewModel())
}
