//
//  GoodToKnowView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 30.06.24.
//

import SwiftUI

struct GoodToKnowView: View {
    // MARK: properties
    @ObservedObject var otherVm: OtherProfileViewModel
    
    // MARK: body
    var body: some View {
        Text("Good to know")
            .appFont(size: 16, textWeight: .semibold)
            .padding(.horizontal)
        
        VStack {
            ForEach(otherVm.goodToKnowRows.indices, id: \.self) { index in
                let row = otherVm.goodToKnowRows[index]
                HStack {
                    Image(systemName: row.icon)
                        .font(.caption)
                        .frame(width: 30)
                    Text(row.text)
                    Spacer()
                }
                .appFont(size: 12, textWeight: .regular)
                
                if index != otherVm.goodToKnowRows.count - 1 {
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
    GoodToKnowView(otherVm: OtherProfileViewModel(otherUser: FireUser(id: "2")))
}
