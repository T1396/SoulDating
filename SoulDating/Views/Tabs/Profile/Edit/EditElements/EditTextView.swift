//
//  EditTextView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 10.06.24.
//

import SwiftUI

struct EditTextView: View {
    @Environment(\.dismiss) var dismiss
    @State private var text: String
    
    init(text: String, onCommit: @escaping (String) -> Void) {
        self._text = State(wrappedValue: text)
        self.onCommit = onCommit
    }
    
    var onCommit: (String) -> Void
    
    var body: some View {
        VStack {
            Spacer()
            
            AppTextField(
                "Anzeigename",
                text: $text,
                error: text.count < 4,
                errorMessage: "Dein Name muss mindestens 4 Zeichen haben",
                supportText: "Das wird dein neuer Anzeigename"
            )
            
            Spacer()
            
            HStack {
                Button("Abbrechen", action: { dismiss() })
                
                Spacer()
                
                Button {
                    print(text)
                    onCommit(text)
                } label: {
                    Text("Aktualisieren")
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
    }
}

#Preview {
    EditTextView(text: "Hallo") { _ in
        
    }
}
