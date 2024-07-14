//
//  TextFieldStyle.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 05.06.24.
//

import Foundation
import SwiftUI

struct AppTextFieldStyle: TextFieldStyle {
    var error: Bool = false
    var errorText: String = ""
    var paddingHorizontal: CGFloat = 20
    var paddingVertical: CGFloat = 12
    @Environment(\.colorScheme) var colorScheme

    @State private var showInfoPopover = false

    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.vertical)
            .padding(.horizontal, paddingHorizontal)
            .appFont(size: 14)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(colorScheme == .light ? .gray.opacity(0.08) : .gray.opacity(0.3))
            )
            .overlay(
                HStack {
                    Spacer()
                    if error {
                        InfoPopoverItem(infoText: errorText, showPopover: $showInfoPopover, systemName: "exclamationmark.circle.fill", color: .red)
                            .font(.title2)
                            .padding(.trailing)
                    }
                }
            )
    }
}

#Preview {
    @State var previewName: String = "Example Job"
    return VStack {
        AppTextField("Enter your job", text: $previewName, error: true, errorMessage: "Enter a longer name for your job", supportText: "", type: .normal)
    }
}
