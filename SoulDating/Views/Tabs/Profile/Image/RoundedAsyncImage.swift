//
//  RoundedAsyncImage.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 11.06.24.
//

import Foundation
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
                    .circularImageStyle(progress: progress)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 250, height: 250)
            .clipped()
        } else {
            Image("profileimage")
                .circularImageStyle(progress: progress)
        }
    }
}
