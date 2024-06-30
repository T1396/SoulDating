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
    var paddingHorizontal: CGFloat = 20
    var paddingVertical: CGFloat = 12
    @Environment(\.colorScheme) var colorScheme
        
    var strokeGradient: LinearGradient {
        LinearGradient(gradient: Gradient(colors: error ? [.red] : [.blue, .purple]), startPoint: .leading, endPoint: .trailing)
    }
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.vertical)
            .padding(.horizontal, paddingHorizontal)
            .appFont(size: 18)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(colorScheme == .light ? .gray.opacity(0.08) : .black.opacity(0.8))
                    .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)
            )
            .overlay(
                HStack {
                    Spacer()
                    if error {
                        Image(systemName: "exclamationmark.circle")
                            .foregroundStyle(.red)
                            .padding(.trailing, 20)
                    }
                }
            )
    }
}

#Preview {
    @State var previewName: String = "Example Job"
    return VStack {
        AppTextField("Enter your job", text: $previewName, error: true, errorMessage: "Enter a longer name for your job", supportText: "", type: .email)
    }
}
