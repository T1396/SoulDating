//
//  ButtonStyle.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 09.06.24.
//

import SwiftUI

struct TextButtonStyle: ViewModifier {
    var color: Color
    func body(content: Content) -> some View {
        content
            .foregroundStyle(.white)
            .padding()
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

extension View {
    func textButtonStyle(color: Color) -> some View {
        self.modifier(TextButtonStyle(color: color))
    }
}


