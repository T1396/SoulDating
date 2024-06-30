//
//  UserProgressImage.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 24.06.24.
//

import SwiftUI

struct UserProgressImage: View {
    var imageUrl: String?
    var width: CGFloat = 250
    var height: CGFloat = 250
    var userProgress: CGFloat = 0.9
    
    var onAppear: ((Image) -> Void)? = nil
    @State private var isLoaded = false

    
    @State var progress: CGFloat = 0.0
    
    var body: some View {
        ZStack {
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
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .padding(4)
                            .frame(width: width, height: height)
                            .onAppear {
                                isLoaded = true
                                if let onAppear {
                                    onAppear(image)
                                }
                            }
                    case .failure(_):
                        PlaceholderImageView(systemName: "wifi.slash", size: CGFloat(34), isLoaded: $isLoaded)
                            .frame(width: CGFloat(width), height: CGFloat(height))
                            .background(.cyan)
                            .clipShape(Circle())
                    @unknown default:
                        EmptyView()
                    }
                }
                .onAppear {
                    withAnimation {
                        progress = (userProgress / 100.0)
                    }
                }
            } else {
                Image("profileimage")
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .padding(4)
                    .frame(width: width, height: height)
                    .onAppear {
                        withAnimation {
                            progress = (userProgress / 100.0)
                        }
                    }
            }
               

            Circle()
                .trim(from: 0, to: progress)
                .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                .foregroundColor(.accent)
                .rotationEffect(Angle(degrees: 270.0))
                .frame(width: width, height: height)
                .animation(.bouncy, value: progress)
        }
        .onChange(of: userProgress) { oldValue, newValue in
            withAnimation {
                progress = (userProgress / 100.0)
            }
        }
    }
}

#Preview {
    UserProgressImage(imageUrl: "", width: 100, height: 100, userProgress: 80.0, onAppear: { _ in })
    //    Image("sampleimage")
//        .circularProgressImageStyle(progress: 0.5, width: 100, height: 100)
}
