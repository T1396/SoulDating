//
//  SwipeImageStyle.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 14.06.24.
//

import SwiftUI

extension Image {
    func clippedImageStyle(width: CGFloat, height: CGFloat) -> some View {
        self
            .resizable()
            .scaledToFill()
            .frame(width: width, height: height)
            .clipped()
    }
}
