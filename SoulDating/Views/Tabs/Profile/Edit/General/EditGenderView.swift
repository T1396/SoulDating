//
//  EditGenderView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 12.06.24.
//

import SwiftUI

struct EditGenderView: View {
    // MARK: properties
    let title: String
    let supportText: String?
    @Binding var initialGender: Gender?
    let path: String

    @EnvironmentObject var editVm: EditUserViewModel
    @State private var chosenGender: Gender?
    @Environment(\.dismiss) var dismiss
    
    // MARK: computed properties
    var updateDisabled: Bool {
        chosenGender == nil || chosenGender == initialGender
    }
    
    // MARK: init
    init(title: String, supportText: String?, initialGender: Binding<Gender?>, path: String) {
        self.title = title
        self.supportText = supportText
        self._initialGender = initialGender
        self._chosenGender = State(wrappedValue: initialGender.wrappedValue)
        self.path = path
    }
    
    // MARK: body
    var body: some View {
        VStack(alignment: .leading) {
            
            Spacer()
            Text(title)
                .appFont(size: 32, textWeight: .bold)
                .padding(.bottom, 2)
            if let supportText {
                Text(supportText)
                    .appFont(size: 16, textWeight: .light)
            }
            ForEach(Gender.allCases) { gender in
                OptionToggleRow(text: gender.title, isSelected: chosenGender == gender) {
                    toggleGender(gender)
                }
                .buttonStyle(PressedButtonStyle())
            }
            
            Spacer()
            
            Button(action: save) {
                Text("Update")
                    .appFont(textWeight: .bold)
            }
            .appButtonStyle(fullWidth: true)
            .disabled(updateDisabled)
        
        }
        .padding()
    }
    
    // MARK: functions
    private func save() {
        editVm.updateUserField(path, with: chosenGender)
        initialGender = chosenGender
    }
    
    private func toggleGender(_ gender: Gender) {
        if chosenGender == gender {
            chosenGender = nil
        } else {
            chosenGender = gender
        }
    }
}

#Preview {
    EditGenderView(title: "Change gender", supportText: "du sdkasld", initialGender: .constant(.male), path: "dlasö")
}
