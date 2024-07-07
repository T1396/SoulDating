//
//  CustomLabel.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 05.07.24.
//

import SwiftUI

struct CustomLabel: View {
    enum Role { case normal, delete }
    let text: String
    let systemName: String
    var showArrow = false
    var labelRole: Role = .normal

    @Environment(\.colorScheme) var colorScheme

    var foregroundStyle: Color {
        switch labelRole {
        case .normal: .black
        case .delete: .red
        }
    }

    var body: some View {
        HStack {
            AppIcon(systemName: systemName, size: .small, role: labelRole == .delete ? .delete : .normal)
            Text(text)
                .foregroundStyle(foregroundStyle)
            Spacer()
            if showArrow {
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .fontWeight(labelRole == .delete ? .bold : .regular)
                    .foregroundStyle(.primary.opacity(0.7))
            }
        }
    }
}

#Preview {
    CustomLabel(text: "hallo", systemName: "xmark")
}
