//
//  EditDescriptionView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 20.06.24.
//

import Foundation
import SwiftUI
import Combine

/// Limits a string binding to an inserted char limit and deletes updates over the limit
extension Binding where Value == String {
    func max(_ limit: Int) -> Self {
        if self.wrappedValue.count > limit {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.prefix(limit))
            }
        }
        return self
    }
}

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
            
            Text("Enter a short description about yourself for other users")
                .padding(.horizontal)
                .appFont(size: 11, textWeight: .bold)
                .foregroundStyle(.gray.opacity(0.8))
            
            TextField("Change your description", text: $newDescription.max(charLimit), axis: .vertical)
                .padding()
                .background(.gray.opacity(0.3), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                .lineLimit(5, reservesSpace: true)
            HStack {
                Text("Enter a more detailed description")
                    .foregroundStyle(.red.opacity(0.7))
                    .appFont(size: 14, textWeight: .bold)
                Spacer()
                Text("\(newDescription.count) / \(charLimit)")
                    .appFont(size: 12)
            }
            .padding(.horizontal)

        

            
            
            Spacer()
            
            HStack {
                Button("Cancel", action: { dismiss() })
                Spacer()
                Button(action: save) {
                    Text("Update")
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
