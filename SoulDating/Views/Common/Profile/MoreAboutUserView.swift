//
//  MoreAboutMeView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 30.06.24.
//

import SwiftUI

struct MoreAboutUserView: View {
    // MARK: properties
    @ObservedObject var otherVm: OtherProfileViewModel
    
    
    // MARK: body
    var body: some View {
        Text("More about me")
            .appFont(size: 16, textWeight: .semibold)
            .padding(.horizontal)
        VStack {
            ForEach(otherVm.moreAboutUser.indices, id: \.self) { index in
                let row = otherVm.moreAboutUser[index]
                HStack {
                    Image(systemName: row.icon)
                        .font(.caption)
                        .frame(width: 30)
                    Text("\(row.title): ")
                    Spacer()
                    Text(row.value)
                        .appFont(size: 12, textWeight: .semibold)
                }
                .appFont(size: 12, textWeight: .regular)
                if index != otherVm.moreAboutUser.count - 1 {
                    Divider()
                        .padding(.horizontal, 4)
                }
            }
        }
        .itemBackgroundStyle()
        .padding(.horizontal)
    }
}

#Preview {
    MoreAboutUserView(otherVm: OtherProfileViewModel(otherUser: FireUser(id: "2")))
}
