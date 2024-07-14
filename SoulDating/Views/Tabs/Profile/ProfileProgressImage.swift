//
//  UserProgressImage.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 24.06.24.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileProgressImage: View {
    // MARK: properties
    var imageUrl: String?
    var width: CGFloat = 250
    var height: CGFloat = 250
    var userProgress: CGFloat = 0.9

    var onAppear: ((Image) -> Void)?

    @State private var isLoaded = false
    @State private var progress: CGFloat = 0.0
    @State private var imageLoadFailed = false

    var body: some View {
        ZStack {
            if imageLoadFailed {
                Image(systemName: "exclamationmark.triangle")
                    .resizable()
                    .scaledToFit()
                    .padding(2)
                    .frame(width: width, height: height)
                    .clipShape(Circle())
                    .background(Color.gray.opacity(0.5))
            } else if let imageUrl, let url = URL(string: imageUrl) {
                WebImage(url: url, options: [.progressiveLoad, .retryFailed]) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .padding(2)
                        .frame(width: width, height: height)
                        .onAppear {
                            isLoaded = true
                            if let onAppear {
                                onAppear(image)
                            }
                        }
                } placeholder: {
                    ProgressView()
                        .scaleEffect(1.5)
                        .frame(width: width, height: height)
                        .background(.secondaryAccent)
                        .clipShape(Circle())
                }
                .onFailure { _ in
                    imageLoadFailed = true
                }
                .onAppear {
                    withAnimation {
                        progress = (userProgress / 100.0)
                    }
                }
            } else {
                Image("placeholder")
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .padding(2)
                    .frame(width: width, height: height)
                    .onAppear {
                        withAnimation {
                            progress = (userProgress / 100.0)
                        }
                    }
            }

            // progress circle
            Circle()
                .trim(from: 0, to: progress)
                .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                .foregroundColor(.accent)
                .rotationEffect(Angle(degrees: 270.0))
                .frame(width: width, height: height)
                .animation(.bouncy, value: progress)
        }
        .onChange(of: userProgress) { _, newValue in
            withAnimation {
                progress = (newValue / 100.0)
            }
        }
    }
}

#Preview {
    ProfileProgressImage(imageUrl: "", width: 100, height: 100, userProgress: 80.0, onAppear: { _ in })
}
