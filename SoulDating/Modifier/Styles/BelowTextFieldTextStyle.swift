//
//  BelowTextFieldTextStyle.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 09.06.24.
//

import SwiftUI

struct BelowTextFieldTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.caption)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

extension View {
    func belowTextFieldTextStyle() -> some View {
        self.modifier(BelowTextFieldTextStyle())
    }
}
