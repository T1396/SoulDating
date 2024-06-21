//
//  RoundedStrokeImageStyle.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 11.06.24.
//

import SwiftUI

extension Image {
    func circularProgressImageStyle(progress: CGFloat, width: Int, height: Int) -> some View {
        self
            .resizable()
            .scaledToFill()
            .clipShape(Circle())
            .frame(width: CGFloat(width), height: CGFloat(height))
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
    
    func roundedImageStyle(width: CGFloat = 48, height: CGFloat = 48, cornerRadius: CGFloat = 14) -> some View {
        self.resizable()
            .scaledToFill()
            .frame(width: width, height: height)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
    
    func circularImageStyle(width: Int, height: Int) -> some View {
        self
            .resizable()
            .scaledToFill()
            .clipShape(Circle())
            .frame(width: CGFloat(width), height: CGFloat(height))
    }
}
