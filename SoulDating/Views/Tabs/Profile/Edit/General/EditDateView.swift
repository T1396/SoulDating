//
//  EditDateView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 10.06.24.
//

import SwiftUI
import Firebase

struct EditDateView: View {
    let title: String
    let oldDate: Date
    
    let path: String
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @Environment(\.dismiss) var dismiss
    @State private var newDate: Date

    
    init(title: String, date: Date, path: String) {
        self.title = title
        self.oldDate = date
        self._newDate = State(initialValue: date)
        self.path = path
    }
    
    var body: some View {
        VStack {
            Text(title)
                .appFont(size: 32, textWeight: .bold)
            
            DatePicker(title, selection: $newDate)
                .datePickerStyle(.wheel)
            
            HStack {
                Button("Cancel", action: { dismiss() })
                Spacer()
                Button(action: save) {
                    Text("Update")
                        .appButtonStyle()
                }
                .disabled(newDate == oldDate)
            }
        }
    }
    
    private func save() {
        profileViewModel.updateUserField(path, with: newDate)
    }
}

#Preview {
    EditDateView(title: "Change your Birthdate", date: .now, path: "dkoasl")
}
