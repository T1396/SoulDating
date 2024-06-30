//
//  EditTextView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 10.06.24.
//

import SwiftUI

struct EditTextFieldView: View {
    let title: String
    let placeholder: String
    let errorMessage: String?
    let supportText: String?
    let path: String
    
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @Environment(\.dismiss) var dismiss
    @State private var newText: String
    
    init(title: String, path: String, text: String, placeholder: String, errorMessage: String?, supportText: String?) {
        self.title = title
        self._newText = State(initialValue: text)
        self.placeholder = placeholder
        self.errorMessage = errorMessage
        self.supportText = supportText
        self.path = path
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .appFont(size: 28, textWeight: .bold)
            Spacer()
            
            AppTextField(
                placeholder,
                text: $newText,
                error: newText.count < 4,
                errorMessage: errorMessage,
                supportText: supportText ?? ""
            )
            
            Spacer()
            
            HStack {
                Button("Cancel", action: { dismiss() })
                
                Spacer()
                
                Button(action: save) {
                    Text("Update")
                        .appButtonStyle()
                }
            }
        }
        .padding()
    }
    
    private func save() {
        profileViewModel.updateUserField(path, with: newText)
    }
}

#Preview {
    EditTextFieldView(title: "Enter your job", path: "d", text: "Spahnmechaniker", placeholder: "Enter your job", errorMessage: "Your job name must be longer than 4 characters", supportText: "Every detail about you gives you better chances")
}
