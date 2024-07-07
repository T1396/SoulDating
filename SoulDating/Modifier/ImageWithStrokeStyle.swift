//
//  ImageWithStrokeStyle.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 24.06.24.
//

import Foundation
import SwiftUI

struct ImageWithStrokeStyle: ViewModifier {
    var strokeColor: Color
    var cornerRadius: CGFloat
    func body(content: Content) -> some View {
        content
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(strokeColor, lineWidth: 2)
            )
    }
}

extension View {
    func imageStrokeStyle(strokeColor: Color = .accent, cornerRadius: CGFloat = 12) -> some View {
        self.modifier(ImageWithStrokeStyle(strokeColor: strokeColor, cornerRadius: cornerRadius))
    }
}
