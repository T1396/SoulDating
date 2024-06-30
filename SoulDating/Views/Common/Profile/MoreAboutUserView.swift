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
            ForEach(otherVm.moreAboutUser, id: \.title) { info in
                HStack {
                    Image(systemName: info.icon)
                        .font(.caption)
                        .frame(width: 30)
                    Text("\(info.title): ")
                    Spacer()
                    Text(info.value)
                        .appFont(size: 12, textWeight: .semibold)
                }
                .appFont(size: 12, textWeight: .regular)
                if info.title != "Smoking Status" {
                    Divider()
                }
            }
        }
        .itemBackgroundStyle()
        .padding(.horizontal)
    }
}

#Preview {
    MoreAboutUserView(otherVm: OtherProfileViewModel(currentUser: User(id: "1"), otherUser: User(id: "2")))
}
