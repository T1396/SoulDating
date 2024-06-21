//
//  ErrorTextField.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 09.06.24.
//

import SwiftUI

struct AppTextField: View {
    // MARK: properties
    var placeholder: String
    @Binding var text: String
    var error: Bool
    var errorMessage: String?
    var supportText: String
    var isSecure: Bool
    
    // MARK: computed properties
    var textToShow: String? {
        error ? errorMessage : supportText
    }
    
    // MARK: body
    var body: some View {
        VStack(alignment: .leading) {
            textField()
                .textFieldStyle(AppTextFieldStyle(error: error))
                .animation(.default, value: error)
            Text(((error == true && errorMessage != nil) ? errorMessage : supportText) ?? "")
                .appFont(size: 12)
                .foregroundStyle(error ? .red : .primary)
                .padding(.leading)
        }
    }
    
    @ViewBuilder
    private func textField() -> some View {
        if isSecure {
            SecureField(placeholder, text: $text)
                .appFont(textWeight: .medium)
        } else {
            TextField(placeholder, text: $text)
                .appFont(textWeight: .medium)
        }
    }
    
    // MARK: init
    init(_ placeholder: String, text: Binding<String>, error: Bool = false, errorMessage: String? = nil, supportText: String = "", isSecure: Bool = false) {
        self.placeholder = placeholder
        self._text = text
        self.error = error
        self.errorMessage = errorMessage
        self.supportText = supportText
        self.isSecure = isSecure
    }
}

#Preview {
    AppTextField("nutzername", text: .constant(""), error: true, errorMessage: "Kein gültiger Username")
}
