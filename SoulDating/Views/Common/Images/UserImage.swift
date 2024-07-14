//
//  UserImage.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 14.06.24.
//

import SwiftUI
import SDWebImageSwiftUI

/// shows
struct UserImage: View {
    // MARK: properties
    let url: String?
    let minWidth: CGFloat
    let minHeight: CGFloat
    
    var onAppear: ((Image) -> Void)?
    
    // MARK: computed properties
    var safeWidth: CGFloat {
        max(0, minWidth)
    }
    
    var safeHeight: CGFloat {
        max(0, minHeight)
    }
    
    var body: some View {
        VStack {
            image()
                .frame(minWidth: safeWidth, maxWidth: safeWidth, minHeight: safeHeight, maxHeight: safeHeight)
        }
    }
    
    @ViewBuilder
    private func image() -> some View {
        if let url, let imageURL = URL(string: url) {
            WebImage(url: imageURL) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .onAppear {
                        if let onAppear { onAppear(image) }
                    }
            } placeholder: {
                placeholderView
            }
            .indicator(.activity)
        } else {
            placeholderView
        }
    }
    
    var placeholderView: some View {
        VStack {
            PlaceholderImageView(systemName: "photo.fill", size: CGFloat(100), isLoaded: .constant(false))
        }
        .background(Color(red: 40, green: 40, blue: 40))
    }
    
    var loadingView: some View {
        VStack {
            ProgressView()
                .scaleEffect(1.5)
        }
        .background(Color(red: 40, green: 40, blue: 40))
    }
}

#Preview {
    UserImage(url: "https://firebasestorage.googleapis.com:443/v0/b/souldating-b6486.appspot.com/o/profileImages%2FHQKJq4QlHiRIf1kF4QAv5qad0F73%2FotherImages%2F6C6AE870-FD99-460E-8D36-7E066367CE3B.jpg?alt=media&token=2156c595-6a34-4a5f-8464-065d9bb177a4", minWidth: 100, minHeight: 133)
}
