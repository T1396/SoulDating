//
//  PressedButtonStyle.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 20.06.24.
//

import Foundation
import SwiftUI

struct PressedButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? Color.gray.opacity(0.2) : .clear)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}
