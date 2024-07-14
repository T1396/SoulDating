//
//  GlobalBackground.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 23.06.24.
//

import Foundation
import SwiftUI

struct GlobalBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color(.systemGroupedBackground).ignoresSafeArea(edges: .all))
    }
}

extension View {
    func globalBackground() -> some View {
        self.modifier(GlobalBackground())
    }
}
