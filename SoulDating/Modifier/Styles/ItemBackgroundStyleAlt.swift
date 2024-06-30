//
//  ItemBackgroundStyleAlt.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 14.06.24.
//

import SwiftUI

struct ItemBackgroundStyleAlt: ViewModifier {
    let color: Color
    let padding: Int
    let cornerRadius: Int
    
    func body(content: Content) -> some View {
        content
            .padding(CGFloat(padding))
            .padding(.horizontal, 2)
            .background(color, in: RoundedRectangle(cornerRadius: CGFloat(cornerRadius), style: .continuous))
    }
}

extension View {
    func itemBackgroundStyleAlt(_ color: Color, padding: Int, cornerRadius: Int) -> some View {
        self.modifier(ItemBackgroundStyleAlt(color: color, padding: padding, cornerRadius: cornerRadius))
    }
}
