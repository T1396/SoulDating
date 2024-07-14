//
//  ErrorTextField.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 09.06.24.
//

import SwiftUI

struct AppTextField: View {
    enum TextFieldType { case normal, password }
    // MARK: properties
    var placeholder: String
    @Binding var text: String
    var error: Bool
    var errorMessage = ""
    var supportText: String
    var type: TextFieldType = .normal
    var keyboardType: UIKeyboardType = .default

    // MARK: computed properties
    var textToShow: String? {
        error ? errorMessage : supportText
    }
    
    // MARK: body
    var body: some View {
        VStack(alignment: .leading) {
            textField()
                .textFieldStyle(AppTextFieldStyle(error: error, errorText: errorMessage))
                .keyboardType(keyboardType)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .appFont(textWeight: .medium)
                .animation(.default, value: error)
            if !errorMessage.isEmpty, !supportText.isEmpty {
                Text(error == true ? errorMessage : supportText)
                    .appFont(size: 12)
                    .foregroundStyle(error ? .red : .primary)
                    .padding(.leading)
            }
        }
        
    }
    
    @ViewBuilder
    private func textField() -> some View {
        switch type {
        case .normal:
            TextField(placeholder, text: $text)
        case .password:
            SecureField(placeholder, text: $text)
        }
    }
    
    // MARK: init
    init(_ placeholder: String, text: Binding<String>, error: Bool = false, errorMessage: String = "", supportText: String = "", type: TextFieldType = .normal, keyboardType: UIKeyboardType = .default) {
        self.placeholder = placeholder
        self._text = text
        self.error = error
        self.errorMessage = errorMessage
        self.supportText = supportText
        self.type = type
        self.keyboardType = keyboardType
    }
}

#Preview {
    AppTextField("nutzername", text: .constant(""), error: true, errorMessage: "Kein gültiger Username")
}
