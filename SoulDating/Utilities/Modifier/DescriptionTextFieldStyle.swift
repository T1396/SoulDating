//
//  DescriptionTextFieldStyle.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 14.07.24.
//

import Foundation
import SwiftUI

struct DescriptionTextFieldStyle: ViewModifier {
    var color: Color
    var lineLimit: Int
    func body(content: Content) -> some View {
        content
            .padding()
            .background(.gray.opacity(0.3), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            .lineLimit(lineLimit, reservesSpace: true)
            .padding(.horizontal)
    }
}

extension TextField {
    func descriptionTextFieldStyle(color: Color = .gray.opacity(0.3), lineLimit: Int = 5) -> some View {
        self.modifier(DescriptionTextFieldStyle(color: color, lineLimit: lineLimit))
    }
}
