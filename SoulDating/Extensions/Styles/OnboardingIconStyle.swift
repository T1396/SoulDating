//
//  OnboardingIconStyle.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 16.06.24.
//

import Foundation
import SwiftUI

struct OnboardingIconStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 80))
            .foregroundStyle(.cyan)
            .frame(maxWidth: .infinity, alignment: .center)
    }
}

extension Image {
    func onboardingIconStyle() -> some View {
        self.modifier(OnboardingIconStyle())
    }
}
