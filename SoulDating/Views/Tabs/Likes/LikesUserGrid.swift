//
//  LikesUserGrid.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 08.07.24.
//

import SwiftUI

struct LikesUserGrid: View {
    var currentUsers: [FireUser]
    @ObservedObject var likesViewModel: LikesViewModel
    var likesTab: LikesTab

    private let gridItems = Array(repeating: GridItem(.flexible()), count: 3)

    init(currentUsers: [FireUser], likesViewModel: LikesViewModel, likesTab: LikesTab) {
        self.currentUsers = currentUsers
        self.likesViewModel = likesViewModel
        self.likesTab = likesTab
        print("initialized likes user grid")
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                Spacer(minLength: 8)
                LazyVGrid(columns: gridItems) {
                    ForEach(currentUsers) { user in
                        let padding: CGFloat = 32
                        let width = (geometry.size.width - padding) / 3
                        let height = width * 4 / 3

                        ImageWithGradientAndName(
                            user: user,
                            distance: likesViewModel.distance(to: user.location),
                            minWidth: width,
                            minHeight: height,
                            textSize: .small
                        )
                    }
                }
                .padding(.horizontal, 10)
            }
        }
    }
}

#Preview {
    LikesUserGrid(currentUsers: [], likesViewModel: LikesViewModel(), likesTab: .likes)
}
