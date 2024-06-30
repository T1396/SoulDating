//
//  UserInterestsView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 30.06.24.
//

import SwiftUI

struct UserInterestsView: View {
    // MARK: properties
    @ObservedObject var otherVm: OtherProfileViewModel
    
    // MARK: body
    var body: some View {
        Text("Interests")
            .appFont(size: 16, textWeight: .semibold)
            .padding(.horizontal)
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(otherVm.interests) { interest in
                    HStack(spacing: 4) {
                        Image(systemName: interest.icon)
                            .font(.caption)
                        Text(interest.title)
                            .appFont(size: 14)
                    }
                    .itemBackgroundTertiary()
                }
            }
            .frame(maxHeight: 28)
            .padding(.horizontal)
        }
        .scrollIndicators(.hidden)
    }
}

#Preview {
    UserInterestsView(otherVm: OtherProfileViewModel(currentUser: User(id: "1"), otherUser: User(id: "2")))
}
