//
//  EditTextView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 10.06.24.
//

import SwiftUI

struct EditNameView: View {
    let title: String
    
    let path: String
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @Environment(\.dismiss) var dismiss
    @State private var newName: String
    
    init(title: String, path: String, text: String) {
        self.title = title
        self._newName = State(initialValue: text)
        self.path = path
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .appFont(size: 32, textWeight: .bold)
            Spacer()
            
            AppTextField(
                "User display name",
                text: $newName,
                error: newName.count < 4,
                errorMessage: "Your name must have at least 4 characters",
                supportText: "This will be your new profile name"
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
        profileViewModel.updateUserField(path, with: newName)
    }
}

#Preview {
    EditNameView(title: "Ändere deinen Namen", path: ".name", text: "")
}
