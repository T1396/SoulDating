//
//  EditNumberView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 23.06.24.
//

import SwiftUI

struct EditHeightView: View {
    // MARK: properties
    let title: String
    let supportText: String?
    let path: String
    @Binding var initialValue: Double?

    @EnvironmentObject var editVm: EditUserViewModel
    @Environment(\.dismiss) var dismiss

    @State private var number: Double
    
    // MARK: computed properties
    var disabledSaving: Bool {
        initialValue == number
    }
    
    // MARK: init
    init(title: String, path: String, initialValue: Binding<Double?>, supportText: String?) {
        self.title = title
        self.supportText = supportText
        self._number = State(initialValue: initialValue.wrappedValue ?? 180)
        self._initialValue = initialValue
        self.path = path
    }
    
    // MARK: body
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .appFont(size: 28, textWeight: .bold)
            Spacer()
            
            Text("\(number, specifier: "%.0f")cm")
                .appFont(size: 22, textWeight: .semibold)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Slider(
                value: $number,
                in: 120...240,
                step: 1
            ) {
                Text("Speed")
            } minimumValueLabel: {
                Text("120cm")
                    .appFont()
            } maximumValueLabel: {
                Text("240cm")
                    .appFont()
            }
            
            Spacer()
            
            HStack {
                Button("Cancel") { dismiss() }
                
                Spacer()
                
                Button(action: save) {
                    Text("Save")
                        .appButtonStyle()
                }
                .disabled(disabledSaving)
            }
        }
        .padding()
    }
    
    private func save() {
        editVm.updateUserField(path, with: number)
        initialValue = number
        dismiss()
    }
}

#Preview {
    EditHeightView(title: "Change your height", path: "1", initialValue: .constant(180), supportText: nil)
}
