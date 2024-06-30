//
//  EditNumberView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 23.06.24.
//

import SwiftUI

struct EditNumberView: View {
    let title: String
    let supportText: String?
    let path: String
    
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @Environment(\.dismiss) var dismiss
    @State private var newText: String
    
    @State private var number = 180.0
    
    init(title: String, path: String, text: String, supportText: String?) {
        self.title = title
        self._newText = State(initialValue: text)
        self.supportText = supportText
        self.path = path
    }
    
    
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
            }
        }
        .padding()
    }
    
    private func save() {
        profileViewModel.updateUserField(path, with: Int(number))
        dismiss()
    }
}

#Preview {
    EditNumberView(title: "Change your height", path: "1", text: "bla", supportText: nil)
}
