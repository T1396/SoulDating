//
//  RoundedStrokeImageStyle.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 11.06.24.
//

import SwiftUI

extension Image {
    func circularImageStyle(progress: CGFloat) -> some View {
        self
            .resizable()
            .scaledToFit()
            .clipShape(Circle())
            .padding(3)
            .overlay(
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .foregroundStyle(.green)
                    .rotationEffect(Angle(degrees: -90))
                    .animation(.linear, value: progress)
                    .blendMode(.sourceAtop)
            )
    }
}
