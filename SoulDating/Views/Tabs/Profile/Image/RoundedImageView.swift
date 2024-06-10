//
//  RoundedImageView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 10.06.24.
//

import SwiftUI

struct RoundedImageView: View {
    var progress: Double
    
    var body: some View {
        Image("profileimage")
            .resizable()
            .scaledToFit()
            .clipShape(Circle())
            .padding(3)
            .overlay(
                Circle()
                    .trim(from: 0, to: CGFloat(progress))
                    .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .foregroundStyle(.green)
                    .rotationEffect(Angle(degrees: -90))
                    .animation(.linear, value: progress)
                    .blendMode(.sourceAtop)
            )
            .frame(width: 200, height: 200)
    }
}

#Preview {
    RoundedImageView(progress: 0.6)
}
