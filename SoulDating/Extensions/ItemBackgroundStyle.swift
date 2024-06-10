//
//  ItemBackgroundStyle.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 09.06.24.
//

import SwiftUI

struct ItemBackgroundStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(8)
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

extension View {
    func itemBackgroundStyle() -> some View {
        self.modifier(ItemBackgroundStyle())
    }
}
