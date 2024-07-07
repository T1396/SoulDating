//
//  InfoPopoverItem.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 07.07.24.
//

import SwiftUI

struct InfoPopoverItem: View {
    let infoText: String
    @Binding var showPopover: Bool
    var body: some View {
        Button(action: {
            showPopover = true
        }, label: {
            Image(systemName: "info.circle.fill")
                .popover(isPresented: $showPopover, attachmentAnchor: .point(.top), arrowEdge: .top) {
                    Text(infoText)
                        .appFont(size: 12, textWeight: .semibold)
                        .padding()
                        .frame(minHeight: 100)
                        .presentationCompactAdaptation(.popover)
                }
        })
    }
}

#Preview {
    InfoPopoverItem(infoText: "Das ist eine Information", showPopover: .constant(true))
}
