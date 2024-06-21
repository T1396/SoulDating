//
//  EditAgeRangeView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 17.06.24.
//

import SwiftUI

struct EditAgeRangeView: View {
    let title: String
    let initialPreference: AgePreference?
    let path: String
    
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @State private var agePreferences: AgePreference
    @Environment(\.dismiss) var dismiss
    
    init(title: String, agePreference: AgePreference?, path: String) {
        self.title = title
        self.initialPreference = agePreference
        self._agePreferences = State(initialValue: agePreference ?? AgePreference(minAge: 18, maxAge: 100))
        self.path = path
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .appFont(size: 32, textWeight: .bold)
            
            AgeRangeSliderView(userLowerbound: $agePreferences.minAge, userUpperbound: $agePreferences.maxAge)
            
            
            Button(action: save) {
                Text("Save")
                    .appButtonStyle(fullWidth: true)
            }
            .disabled(initialPreference == agePreferences)
        }
        .padding()
    }
    
    private func save() {
        profileViewModel.updateUserField(path, with: agePreferences)
    }
}

#Preview {
    EditAgeRangeView(title: "aldlsöad", agePreference: AgePreference(minAge: 18, maxAge: 22), path: "dlasö")
}
