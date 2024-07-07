//
//  LookingForView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 30.06.24.
//

import SwiftUI

struct LookingForView: View {
    // MARK: properties
    @ObservedObject var otherVm: OtherProfileViewModel
    
    // MARK: body
    var body: some View {
        Text("Looks for")
            .appFont(size: 16, textWeight: .semibold)
            .padding(.horizontal)
        VStack {
            HStack {
                Image(systemName: "poweroutlet.type.k.fill")
                    .font(.caption)
                    .frame(width: 30)
                Text(otherVm.otherUser.ageAndGenderPrefString)
                Spacer()
            }
            .appFont(size: 12, textWeight: .regular)
            Divider()
                .padding(.horizontal, 4)
            ForEach(otherVm.preferenceDetails, id: \.title) { detail in
                HStack {
                    Image(systemName: detail.icon)
                        .font(.caption)
                        .frame(width: 30)
                    Text(detail.title)
                        .appFont(size: 12, textWeight: .regular)
                    Spacer()
                    if let isAccepted = detail.pref {
                        Image(systemName: isAccepted ? "checkmark.square.fill" : "xmark.app.fill")
                            .foregroundStyle(isAccepted ? .green : .red)
                    } else {
                        Image(systemName: "questionmark.app.fill")
                    }
                }
                if detail.title != "Childs" {
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
    LookingForView(otherVm: OtherProfileViewModel(otherUser: FireUser(id: "2")))
}
