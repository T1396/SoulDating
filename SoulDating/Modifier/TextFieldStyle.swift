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
    @Environment(\.colorScheme) var colorScheme
        
    var strokeGradient: LinearGradient {
        LinearGradient(gradient: Gradient(colors: error ? [.red] : [.blue, .purple]), startPoint: .leading, endPoint: .trailing)
    }
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(colorScheme == .light ? .gray.opacity(0.12) : .black.opacity(0.8))

                    .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(strokeGradient, lineWidth: 1.5)
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
