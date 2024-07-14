//
//  EditDescriptionView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 20.06.24.
//

import Foundation
import SwiftUI
import Combine



struct EditDescriptionView: View {
    let title: String
    let placeholder: String
    let path: String
    
    let charLimit = 200
    @EnvironmentObject var editVm: EditUserViewModel
    @Environment(\.dismiss) var dismiss
    @Binding var initialDescription: String?
    @State private var newDescription: String
    
    var buttonDisabled: Bool {
        newDescription.count < 20 || newDescription == initialDescription || newDescription.isEmpty
    }
    
    init(title: String, initialDescription: Binding<String?>, placeholder: String, path: String) {
        self.title = title
        self.placeholder = placeholder
        self._initialDescription = initialDescription
        self._newDescription = State(initialValue: initialDescription.wrappedValue ?? "")
        self.path = path
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .appFont(size: 32, textWeight: .bold)
            Spacer()
            
            Text(Strings.enterDescText)
                .padding(.horizontal)
                .appFont(size: 11, textWeight: .bold)
                .foregroundStyle(.gray.opacity(0.8))
            
            TextField(Strings.changeDescription, text: $newDescription.max(charLimit), axis: .vertical)
                .padding()
                .background(.gray.opacity(0.3), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                .lineLimit(5, reservesSpace: true)
            HStack {
                Text(Strings.enterMoreDesc)
                    .foregroundStyle(.red.opacity(0.7))
                    .appFont(size: 14, textWeight: .bold)
                Spacer()
                Text("\(newDescription.count) / \(charLimit)")
                    .appFont(size: 12)
            }
            .padding(.horizontal)

        

            
            
            Spacer()
            
            HStack {
                Button(Strings.cancel, action: { dismiss() })
                Spacer()
                Button(action: save) {
                    Text(Strings.update)
                        .appButtonStyle()
                }
                .disabled(buttonDisabled)
            }
        }
        .padding()
    }

    private func save() {
        editVm.updateUserField(path, with: newDescription)
        initialDescription = newDescription
        dismiss()
    }
}

#Preview {
    EditDescriptionView(title: "Ändere deine Beschreibung", initialDescription: .constant("Gurke"), placeholder: "Gurken", path: "dksal")
}
