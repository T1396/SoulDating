//
//  ErrorTextField.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 09.06.24.
//

import SwiftUI

struct AppTextField: View {
    enum TextFieldType { case normal, email, password }
    // MARK: properties
    var placeholder: String
    @Binding var text: String
    var error: Bool
    var errorMessage: String?
    var supportText: String
    var type: TextFieldType = .normal
    
    // MARK: computed properties
    var textToShow: String? {
        error ? errorMessage : supportText
    }
    
    // MARK: body
    var body: some View {
        VStack(alignment: .leading) {
            textField()
                .textFieldStyle(AppTextFieldStyle(error: error))
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .appFont(textWeight: .medium)
                .animation(.default, value: error)
            if let errorMessage, !supportText.isEmpty {
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
        case .email:
            TextField(placeholder, text: $text)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
        case .password:
            SecureField(placeholder, text: $text)
        }
        
    }
    
    // MARK: init
    init(_ placeholder: String, text: Binding<String>, error: Bool = false, errorMessage: String? = nil, supportText: String = "", type: TextFieldType = .normal) {
        self.placeholder = placeholder
        self._text = text
        self.error = error
        self.errorMessage = errorMessage
        self.supportText = supportText
        self.type = type
    }
}

#Preview {
    AppTextField("nutzername", text: .constant(""), error: true, errorMessage: "Kein gültiger Username")
}
