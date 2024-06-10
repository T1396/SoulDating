//
//  ErrorTextField.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 09.06.24.
//

import SwiftUI

struct ErrorTextField: View {
    @Binding var text: String
    var placeholder: String
    var error: Bool
    var errorMessage: String?
    var supportText: String = ""
    
    var textToShow: String? {
        error ? errorMessage : supportText
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField(placeholder, text: $text)
                .textFieldStyle(AppTextFieldStyle(error: error))
                .foregroundStyle(.black)
                .animation(.default, value: error)
            
            Text(((error == true && errorMessage != nil) ? errorMessage : supportText) ?? "")
                .font(.caption)
                .foregroundStyle(error ? .red : .primary)
                .padding(.leading)
        }
    }
}

#Preview {
    ErrorTextField(text: .constant(""), placeholder: "Placeholder", error: false, errorMessage: "Du musst was anderes eingeben!", supportText: "Support Text")
}
