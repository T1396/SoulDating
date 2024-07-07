//
//  ReportOptionRow.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 16.06.24.
//

import SwiftUI



struct OptionRow: View {
    var systemName: String = ""
    let text: String
    let buttonRole: ButtonRole = .destructive
    var action: () -> Void
    
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        Button(role: buttonRole, action: action) {
            HStack {
                if !systemName.isEmpty {
                    Image(systemName: systemName)
                        .resizable()
                        .frame(width: 16, height: 16)
                }
                Text(text)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
            }
        }
        .appFont(size: 16, textWeight: .medium)
        .itemBackgroundStyle(padding: 14)
    }
}

struct OptionToggleRow: View {
    var systemName: String = ""
    let text: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                if !systemName.isEmpty {
                    ZStack {
                        Image(systemName: systemName)
                            .frame(width: 24, height: 24, alignment: .center)
                    }
                }
                Text(text)
                Spacer()
                ToggleView(isSelected: isSelected)
            }
            .appFont(size: 18, textWeight: .medium)
            .itemBackgroundStyle(padding: 14)
        }
        .buttonStyle(PressedButtonStyle())
    }
}

#Preview {
    OptionRow(systemName: "heart.fill", text: "Like den user", action: {})
}

#Preview {
    OptionToggleRow(systemName: "heart.fill", text: "Like irgendwas", isSelected: true, action: {})
}
