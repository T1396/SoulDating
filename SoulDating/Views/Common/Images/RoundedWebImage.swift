//
//  RoundedAsyncImage.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 14.06.24.
//

import SwiftUI
import SDWebImageSwiftUI

struct RoundedWebImage: View {
    // MARK: properties
    var imageUrl: String?
    var width: CGFloat = 250
    var height: CGFloat = 250
    
    var onAppear: ((Image) -> Void)?
    
    // MARK: body
    var body: some View {
        VStack {
            if let imageUrl {
                WebImage(url: URL(string: imageUrl)) { image in
                    image
                        .roundedImageStyle(width: width, height: height)
                        .onAppear {
                            if let onAppear {
                                onAppear(image)
                            }
                        }
                } placeholder: {
                    ProgressView()
                }
            } else {
                Image("profileimage")
                    .roundedImageStyle(width: width, height: height)
            }
        }
        .frame(width: width, height: height)
    }
}

#Preview {
    RoundedWebImage()
}
