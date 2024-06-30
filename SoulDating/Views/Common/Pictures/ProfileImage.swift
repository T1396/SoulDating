//
//  ProfileImage.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 23.06.24.
//

import SwiftUI

struct ProfileImage: View {
    let url: String?
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        if let url {
            AsyncImage(url: URL(string: url)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .scaleEffect(1.5)
                        .frame(width: width, height: height)
                        .background(Color.gray.opacity(0.3)) //
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: width, height: height)
                case .failure(_):
                    Image(systemName: "photo.fill")
                        .resizable()
                        .scaledToFit()
                        .padding()
                        .frame(width: width, height: height)
                        .background(Color.red.opacity(0.2))
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: width, height: height)
            .clipped()
        } else {
            Image(systemName: "photo.fill")
                .resizable()
                .scaledToFit()
                .padding()
                .frame(width: width, height: height)
                .background(Color.red.opacity(0.2))
        }
    }
}

#Preview {
    ProfileImage(url: nil, width: 80, height: 80)
}
