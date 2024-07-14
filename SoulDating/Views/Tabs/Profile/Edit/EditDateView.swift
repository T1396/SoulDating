//
//  EditDateView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 10.06.24.
//

import SwiftUI
import Firebase

struct EditDateView: View {
    // MARK: init
    @EnvironmentObject var editVm: EditUserViewModel
    @Environment(\.dismiss) var dismiss

    let title: String
    @Binding var initialDate: Date?
    let path: String

    @State private var newDate: Date

    // MARK: init
    init(title: String, date: Binding<Date?>, path: String) {
        self.title = title
        self._initialDate = date
        self._newDate = State(initialValue: date.wrappedValue ?? Date().subtractYears(18))
        self.path = path
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .appFont(size: 32, textWeight: .bold)

            DatePicker(selection: $newDate, displayedComponents: .date) {
                
            }
            .labelsHidden()
            .frame(maxWidth: .infinity, alignment: .center)
            .datePickerStyle(.wheel)
            
            HStack {
                Button(Strings.cancel) { dismiss() }
                Spacer()
                Button(action: save) {
                    Text(Strings.update)
                        .appButtonStyle()
                }
                .disabled(newDate == initialDate)
            }
        }
        .padding()
    }
    
    private func save() {
        editVm.updateUserField(path, with: newDate)
        initialDate = newDate
    }
}

#Preview {
    EditDateView(title: "Change your Birthdate", date: .constant(.now), path: "dkoasl")
        .environment(\.locale, Locale(identifier: "ja-JP"))
}
