//
//  SubTitleStyle.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 09.06.24.
//

import SwiftUI

struct SubTitleStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundStyle(.gray.opacity(0.7))
    }
}

extension View {
    func subTitleStyle() -> some View {
        self.modifier(SubTitleStyle())
    }
}
