//
//  RoundedAsyncImage.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 14.06.24.
//

import SwiftUI

struct RoundedAsyncImage: View {
    var imageUrl: String?
    var progress: Double = 0
    var width: Int = 250
    var height: Int = 250
    
    var body: some View {
        if let imageUrl {
            AsyncImage(url: URL(string: imageUrl)) { image in
                image
                    .roundedImageStyle(width: CGFloat(width), height: CGFloat(height))
            } placeholder: {
                ProgressView()
            }
        } else {
            Image("profileimage")
                .roundedImageStyle(width: CGFloat(width), height: CGFloat(height))
        }
    }
}

#Preview {
    RoundedAsyncImage()
}
