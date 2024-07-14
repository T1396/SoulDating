//
//  ItemBackgroundTert.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 28.06.24.
//

import Foundation
import SwiftUI

struct ItemBackgroundTert: ViewModifier {
    var textSize: CGFloat
    var textWeight: AppFont.TextWeight
    var padding: CGFloat
    var horizontalExtraPadd: CGFloat
    func body(content: Content) -> some View {
        content
            .appFont(size: textSize, textWeight: .semibold)
            .padding(.horizontal, horizontalExtraPadd)
            .itemBackgroundStyle(padding: padding)
    }
}

extension View {
    func itemBackgroundTertiary(textSize: CGFloat = 10, padding: CGFloat = 6, horizontalExtra: CGFloat = 12, textWeight: AppFont.TextWeight = .semibold) -> some View {
        self.modifier(ItemBackgroundTert(textSize: textSize, textWeight: textWeight, padding: padding, horizontalExtraPadd: horizontalExtra))
    }
}
