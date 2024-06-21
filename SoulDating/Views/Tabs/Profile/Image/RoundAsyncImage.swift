//
//  RoundedAsyncImage.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 11.06.24.
//

import Foundation
import SwiftUI

struct RoundAsyncImage: View {
    var imageUrl: String?
    var progress: Double = 0
    var width: Int = 250
    var height: Int = 250
    @State private var isLoaded = false
    
    var body: some View {
        if let imageUrl, let url = URL(string: imageUrl) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .scaleEffect(1.5)
                        .frame(width: CGFloat(width), height: CGFloat(height))
                        .background(.cyan)
                        .clipShape(Circle())
                case .success(let image):
                    image
                        .circularImageStyle(width: width, height: height)
                        .onAppear { isLoaded = true }
                case .failure(_):
                    ErrorImageView(systemName: "wifi.slash", size: CGFloat(34), isLoaded: $isLoaded)
                        .frame(width: CGFloat(width), height: CGFloat(height))
                        .background(.cyan)
                        .clipShape(Circle())
                @unknown default:
                    EmptyView()
                }
            }
        } else {
            Image("profileimage")
                .circularProgressImageStyle(progress: progress, width: width, height: width)
        }
    }
}

#Preview {
    VStack {
        RoundAsyncImage(imageUrl: "https://firebasestorage.googleapis.com:443/v0/b/souldating-b6486.appspot.com/o/profileImages%2F66K5In3reXQc8mMuqdkISd3l4I63%2F64C16806-76D0-407C-96E4-7F6DDE7CF7F8.jpg?alt=media&token=3dab4679-4cc7-471a-9de4-75e29b3395ad", progress: 50, width: 50, height: 50)
        
        Text("Hallo")
    }
}


