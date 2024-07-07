//
//  EditBoolView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 21.06.24.
//

import SwiftUI

/// generic view that is used to edit user details where the decision has 2 Options
/// e.g. if the user dates smoker or drinker
struct EditBoolView: View {
    // MARK: properties
    let fieldName: String
    var title: String
    var subtitle: String?
    @Binding var initialIsEnabled: Bool?

    @EnvironmentObject var editVm: EditUserViewModel
    @Environment(\.dismiss) var dismiss
    @State private var isEnabled: Bool
    
    // MARK: computed properties
    var saveDisabled: Bool {
        initialIsEnabled == isEnabled
    }
    
    // MARK: init
    init(title: String, subtitle: String?, isEnabled: Binding<Bool?>, fieldName: String) {
        self.title = title
        self.subtitle = subtitle
        self._isEnabled = State(initialValue: isEnabled.wrappedValue ?? false)
        self._initialIsEnabled = isEnabled
        self.fieldName = fieldName
    }

    // MARK: body
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Change your preference")
                .appFont(size: 20, textWeight: .bold)
            if let subtitle {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)

            }
            Toggle(isOn: $isEnabled) {
                Text(title)
                    .appFont(size: 16, textWeight: .semibold)
            }
            .toggleStyle(SymbolToggleStyle())
            
            
            Button(action: saveChanges) {
                Text("Save")
                    .appButtonStyle(fullWidth: true)
            }
            .disabled(saveDisabled)
        }
        .padding()
    }
    
    // MARK: functions
    private func saveChanges() {
        editVm.updateUserField(fieldName, with: isEnabled)
        initialIsEnabled = isEnabled
        dismiss()
    }
}

#Preview {
    EditBoolView(title: "Do you date smoker?", subtitle: nil, isEnabled: .constant(true), fieldName: "dsa")
}
