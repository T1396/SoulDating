//
//  EditDescriptionView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 20.06.24.
//

import Foundation
import SwiftUI

struct EditDescriptionView: View {
    let title: String
    let placeholder: String
    let path: String
    
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @Environment(\.dismiss) var dismiss
    @State private var newDescription: String
    
    init(title: String, initialDescription: String, placeholder: String, path: String) {
        self.title = title
        self.placeholder = placeholder
        self.newDescription = initialDescription
        self.path = path
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .appFont(size: 32, textWeight: .bold)
            Spacer()
            
            
            TextField(placeholder, text: $newDescription)
            
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
    }
    
    private func save() {
        profileViewModel.updateUserField(path, with: newDescription)
    }
}

#Preview {
    EditDescriptionView(title: "Ändere deine Beschreibung", initialDescription: "Gurke", placeholder: "Gurken", path: "dksal")
}
