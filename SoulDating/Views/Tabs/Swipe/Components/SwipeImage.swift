//
//  SwipeImage.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 14.06.24.
//

import SwiftUI
struct SwipeImage: View {
    let url: String?
    let width: CGFloat
    let height: CGFloat
    
    @State private var isLoaded = false
    
    var body: some View {
        // load user image if url is present
        VStack {
            if let url, let imageURL = URL(string: url) {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .empty:
                        loadingView
                    case .success(let image):
                        image
                            .clippedImageStyle(width: width, height: height)
                            .opacity(isLoaded ? 1 : 0)
                            .animation(.easeIn(duration: 0.5), value: isLoaded)
                            .onAppear { isLoaded = true }
                    case .failure(_):
                        errorView
                    @unknown default:
                        errorView
                    }
                }
            } else {
                VStack {
                    Image(systemName: "person.fill")
                        .resizable()
                        .scaledToFit()
                        .padding(60)
                }.frame(width: width, height: height)
            }
        }
        .frame(width: width, height: height)
    }
    
    var errorView: some View {
        VStack {
            ErrorImageView(systemName: "wifi.slash", size: CGFloat(100), isLoaded: $isLoaded)
                .opacity(isLoaded ? 1 : 0)
                .animation(.easeIn(duration: 0.5), value: isLoaded)
                .onAppear { isLoaded = true }
        }
        .background(.red.opacity(0.2))
        .frame(width: width, height: height)
    }
    
    var loadingView: some View {
        VStack {
            ProgressView()
                .scaleEffect(1.5)
                .frame(width: width, height: height)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    SwipeImage(url: "", width: .infinity, height: .infinity)
}
