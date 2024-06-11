//
//  ItemBackgroundStyle.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 09.06.24.
//

import SwiftUI

struct ItemBackgroundStyle: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    var backgroundColor: Color {
        colorScheme == .light ? .gray.opacity(0.1) : .gray.opacity(0.3)
    }
    
    func body(content: Content) -> some View {
        content
            .padding(8)
            .background(backgroundColor, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

extension View {
    func itemBackgroundStyle() -> some View {
        self.modifier(ItemBackgroundStyle())
    }
}


#Preview {
    VStack {
        Text("Hallo World")
    }
    .itemBackgroundStyle()
}
