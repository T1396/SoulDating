//
//  ItemBackgroundStyle.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 09.06.24.
//

import SwiftUI

struct ItemBackgroundStyle: ViewModifier {
    var padding: CGFloat = 8
    @Environment(\.colorScheme) var colorScheme
    
    var backgroundColor: Color {
        colorScheme == .light ? .gray.opacity(0.1) : .gray.opacity(0.3)
    }
    
    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(backgroundColor, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

extension View {
    func itemBackgroundStyle(padding: CGFloat = 8) -> some View {
        self.modifier(ItemBackgroundStyle(padding: padding))
    }
}


#Preview {
    VStack {
        Text("Hallo World")
    }
    .itemBackgroundStyle()
}
