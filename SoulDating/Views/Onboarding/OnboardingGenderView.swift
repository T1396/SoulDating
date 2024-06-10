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
                
                
                Spacer()
                Spacer()
                
                NavigationLink(destination: OnboardingLocationView(viewModel: viewModel)) {
                    Text("Weiter")
                        .textButtonStyle(color: buttonBackground)
                }
                .disabled(!viewModel.userIsOldEnough)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding()
        }
    }
}

#Preview {
    OnboardingGenderView(viewModel: OnboardingViewModel())
}
