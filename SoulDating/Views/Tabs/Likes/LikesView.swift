//
//  LikesView.swift
//
//
//  Created by Philipp Tiropoulos on 10.06.24.
//

import SwiftUI

struct LikesView: View {
    @StateObject private var likesViewModel: LikesViewModel
    
    init(user: User) {
        self._likesViewModel = StateObject(wrappedValue: LikesViewModel(user: user))
    }
    
    private let gridItems = Array(repeating: GridItem(.flexible()), count: 3)

    var body: some View {
        GeometryReader { geometry in

            ScrollView {
                LazyVGrid(columns: gridItems) {
                    ForEach(likesViewModel.usersWhoLikedCurrentUser) { user in
                        let width = (geometry.size.width - 40 - 40) / 3
                        let height = width * 4 / 3 

                        ImageWithGradientAndName(user: user, distance: likesViewModel.distance(to: user.location), minWidth: width, minHeight: height, textSize: .small)
                    }
                }
                .padding(.horizontal, 20)
            }
            
        }
        .navigationTitle(Tab.likes.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    LikesView(user: User(id: "1", name: "DASjkdsajdk"))
}
