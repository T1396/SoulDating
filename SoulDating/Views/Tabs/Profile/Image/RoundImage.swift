//
//  RoundedImageView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 10.06.24.
//

import SwiftUI

struct RoundImage: View {
    var uiImage: UIImage = UIImage(named: "profileimage") ?? UIImage()
    var progress: Double = 0
    var width: Int = 200
    var height: Int = 200
    
    var body: some View {
        Image(uiImage: uiImage)
            .resizable()
            .scaledToFill()
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
            .frame(width: CGFloat(width), height: CGFloat(height))
    }
}

#Preview {
    VStack {
        RoundImage(progress: 80)
            .background(.blue.opacity(0.2))
        
        Text("Hallo")
    }
}
