//
//  ButtonStyle.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 15.06.24.
//

import SwiftUI

struct AppButtonStyle: ViewModifier {
    enum ButtonType {
        case primary, secondary
        
        @ViewBuilder
        func backgroundStyle(color: Color, isEnabled: Bool, cornerRadius: CGFloat) -> some View {
            let baseColor = isEnabled ? color : .gray.opacity(0.6)
            switch self {
            case .primary:
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(baseColor)
            case .secondary:
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(baseColor.tertiary)
            }
        }
        
        func foregroundColor(isEnabled: Bool) -> Color {
            switch self {
            case .primary:
                return isEnabled ? .buttonText : .gray
            case .secondary:
                return isEnabled ? .primary.opacity(0.9) : .gray
            }
        }
        
    }
    var color: Color
    var type: ButtonType
    var textSize: CGFloat
    var cornerRadius: CGFloat
    var fullWidth: Bool
    
    @Environment(\.isEnabled) var isEnabled: Bool
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: fullWidth ? .infinity : nil)
            .appFont(size: textSize, textWeight: .medium)
            .foregroundStyle(type.foregroundColor(isEnabled: isEnabled))
            .padding()
            .background(
                type.backgroundStyle(
                    color: color,
                    isEnabled: isEnabled,
                    cornerRadius: cornerRadius
                )
            )
            .contentShape(Rectangle())
    }
}

extension View {
    func appButtonStyle(color: Color = .accentColor, type: AppButtonStyle.ButtonType = .primary, textSize: CGFloat = 18, cornerRadius: CGFloat = 14, fullWidth: Bool = false) -> some View {
        self.modifier(AppButtonStyle(color: color, type: type, textSize: textSize, cornerRadius: cornerRadius, fullWidth: fullWidth))
    }
}



#Preview {
    Button {
        
    } label: {
        Text("Button")
            .appButtonStyle()
    }
    .disabled(false)
    .buttonStyle(PressedButtonStyle())
}


