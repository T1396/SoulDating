//
//  SettingsElement.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 10.06.24.
//

import SwiftUI

struct ProfileItemRow: View {
    // MARK: properties
    let title: String
    var value: String?
    var systemName: String?

    @Environment(\.colorScheme) var colorScheme

    // MARK: computed properties
    var valueText: String {
        if let value, !value.isEmpty {
            value
        } else {
            Strings.notSpecified
        }
    }
    
    // MARK: body
    var body: some View {
        HStack(spacing: 16) {
            if let systemName {
                AppIcon(systemName: systemName, size: .medium)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .foregroundStyle(colorScheme == .dark ? .white : .black)
                    .appFont(size: 12)
                Text(valueText)
                    .appFont(size: 10)
                    .foregroundStyle(.gray.opacity(0.9))
                    .lineLimit(1)

            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption)
                .padding(.trailing, 6)
            
        }
    }
}

#Preview {
    ProfileItemRow(title: "Name", value: "Klaus", systemName: "trash")
        .padding()
        .environmentObject(UserViewModel())
}
