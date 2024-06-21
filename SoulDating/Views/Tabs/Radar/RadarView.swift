//
//  RadarView.swift
//
//
//  Created by Philipp Tiropoulos on 10.06.24.
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
                    Image(systemName: "exclamationmark.icloud.fill")
                        .resizable()
                        .scaledToFill()
                        .scaledToFit()
                        .frame(width: width, height: height)
                        .background(Color.red.opacity(0.2))
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: width, height: height)
            .clipped()
        } else {
            Image(systemName: "exclamationmark.arrow.triangle.2.circlepath")
                .resizable()
                .scaledToFit()
                .frame(width: width, height: height)
                .background(Color.red.opacity(0.2))
                .frame(width: width, height: height)
                .clipped()
        }
    }
}


struct RadarView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    
    @StateObject private var radarViewModel: RadarViewModel
    
    init(user: User) {
        self._radarViewModel = StateObject(wrappedValue: RadarViewModel(user: user))
    }
    
    private let gridItems = [ GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                let width = (geometry.size.width - 40) / 2
                ScrollView {
                    LazyVGrid(columns: gridItems, content: {
                        ForEach(radarViewModel.allUsersInRange) { user in
                            ZStack(alignment: .bottom) {
                                ProfileImage(url: user.profileImageUrl, width: width, height: 300)
                                
                                
                                LinearGradient(colors: [.clear, .black], startPoint: .center, endPoint: .bottom)
                                
                                HStack(spacing: 4) {
                                    Text(user.nameAgeString)
                                        .appFont(size: 21, textWeight: .bold)
                                        .foregroundStyle(.white)
                                    Image(systemName: "circle.fill")
                                        .foregroundStyle(.green)
                                    
                                }
                                .offset(x: 5)
                                .padding(6)
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        }
                    }).padding(.horizontal)
                }
            }
            .navigationTitle(Tab.radar.title)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    RadarView(user: User(id: "1", name: "Hannes"))
}
