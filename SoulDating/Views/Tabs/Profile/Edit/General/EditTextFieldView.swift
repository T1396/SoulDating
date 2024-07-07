//
//  EditTextView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 10.06.24.
//

import SwiftUI

struct EditTextFieldView: View {
    // MARK: properties
    let title: String
    let placeholder: String
    let errorMessage: String?
    let supportText: String?
    let path: String
    @Binding var initialText: String?

    @EnvironmentObject var editVm: EditUserViewModel
    @Environment(\.dismiss) var dismiss
    @State private var newText: String
    
    // MARK: computed properties
    var saveDisabled: Bool {
        initialText == newText || newText.isEmpty || newText.count < 4
    }
    
    // MARK: init
    init(title: String, path: String, initialText: Binding<String?>, placeholder: String, errorMessage: String?, supportText: String?) {
        self.title = title
        self._initialText = initialText
        self._newText = State(initialValue: initialText.wrappedValue ?? "")
        self.placeholder = placeholder
        self.errorMessage = errorMessage
        self.supportText = supportText
        self.path = path
    }
    
    // MARK: body
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
                .disabled(saveDisabled)
            }
        }
        .padding()
    }
    // MARK: functions
    private func save() {
        editVm.updateUserField(path, with: newText)
        initialText = newText
    }
}

#Preview {
    EditTextFieldView(title: "Enter your job", path: "d", initialText: .constant("Spahnmechaniker"), placeholder: "Enter your job", errorMessage: "Your job name must be longer than 4 characters", supportText: "Every detail about you gives you better chances")
}
