//
//  RoundedStrokeImageStyle.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 11.06.24.
//

import SwiftUI

extension Image {
    func circularProgressImageStyle(progress: CGFloat, width: CGFloat, height: CGFloat) -> some View {
        self
            .resizable()
            .scaledToFill()
            .clipShape(Circle())
            .padding(3)
            .overlay(
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .foregroundStyle(.accent)
                    .rotationEffect(Angle(degrees: -90))
                    .animation(.linear(duration: 1), value: progress)
                    .blendMode(.sourceAtop)
            )
            .frame(width: width, height: height)
    }
    
    func roundedImageStyle(width: CGFloat = 48, height: CGFloat = 48, cornerRadius: CGFloat = 14) -> some View {
        self.resizable()
            .scaledToFill()
            .frame(width: width, height: height)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
    
    func circularImageStyle(width: CGFloat, height: CGFloat) -> some View {
        self
            .resizable()
            .scaledToFill()
            .clipShape(Circle())
            .frame(width: width, height: height)
    }
}
