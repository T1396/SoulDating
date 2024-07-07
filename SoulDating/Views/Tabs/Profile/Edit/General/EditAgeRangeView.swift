//
//  EditAgeRangeView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 17.06.24.
//

import SwiftUI

struct EditAgeRangeView: View {
    let title: String
    @Binding var initialPreference: AgePreference?
    let path: String
    
    @EnvironmentObject var editVm: EditUserViewModel
    @State private var agePreferences: AgePreference
    @Environment(\.dismiss) var dismiss
    
    init(title: String, agePreference: Binding<AgePreference?>, path: String) {
        self.title = title
        self._initialPreference = agePreference
        self._agePreferences = State(initialValue: agePreference.wrappedValue ?? AgePreference(minAge: 18, maxAge: 100))
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
        editVm.updateUserField(path, with: agePreferences.toDictionary())
        initialPreference = agePreferences
        dismiss()
    }
}

#Preview {
    EditAgeRangeView(title: "aldlsöad", agePreference: .constant(AgePreference(minAge: 18, maxAge: 22)), path: "dlasö")
}
