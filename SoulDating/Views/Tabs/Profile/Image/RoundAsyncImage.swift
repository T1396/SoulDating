//
//  RoundedAsyncImage.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 11.06.24.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI

struct RoundAsyncImage: View {
    var imageUrl: String?
    var width: CGFloat = 250
    var height: CGFloat = 250
    var userProgress: Double = 0.9

    var onAppear: ((Image) -> Void)?

    @State private var isLoaded = false
    @State private var progress: Double

    init(imageUrl: String? = nil, width: CGFloat, height: CGFloat, onAppear: ((Image) -> Void)? = nil, userProgress: Double = 0.0) {
        self.imageUrl = imageUrl
        self.width = width
        self.height = height
        self.onAppear = onAppear
        self._progress = State(initialValue: 0.0)
        self.userProgress = progress
    }

    var body: some View {
        if let imageUrl, let url = URL(string: imageUrl) {
            WebImage(url: url) { image in
                image
                    .circularImageStyle(width: width, height: height)
            } placeholder: {
                VStack {
                    PlaceholderImageView(systemName: "wifi.slash", size: CGFloat(34), isLoaded: $isLoaded)
                }
                .frame(width: width, height: height)
                .background(.secondaryAccent)
                .clipShape(Circle())
            }
            .onAppear {
                withAnimation {
                    progress = userProgress
                }
            }

        } else {
            Image("profileimage")
                .circularProgressImageStyle(progress: CGFloat(progress), width: width, height: width)
        }
    }
}

#Preview {
    VStack {

        RoundAsyncImage(imageUrl: "https://firebasestorage.googleapis.com:443/v0/b/souldating-b6486.appspot.com/o/profileImages%2F66K5In3reXQc8mMuqdkISd3l4I63%2F64C16806-76D0-407C-96E4-7F6DDE7CF7F8.jpg?alt=media&token=3dab4679-4cc7-471a-9de4-75e29b3395ad", width: 100, height: 100, onAppear: { _ in }, userProgress: 0.4)

        Text("Hallo")
    }
}
