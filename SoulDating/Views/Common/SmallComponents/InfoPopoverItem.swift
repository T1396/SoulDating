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
    var anchor: PopoverAttachmentAnchor = .point(.top)
    var arrowEdge: Edge = .top
    var systemName = "info.circle.fill"
    var color: Color = .accent
    var body: some View {
        Button(action: {
            showPopover = true
        }, label: {
            Image(systemName: systemName)
                .popover(isPresented: $showPopover, attachmentAnchor: .point(.top), arrowEdge: .top) {
                    Text(infoText)
                        .appFont(size: 12, textWeight: .semibold)
                        .padding()
                        .frame(minHeight: 100)
                        .presentationCompactAdaptation(.popover)
                }
                .foregroundStyle(color)
        })
    }
}

#Preview {
    VStack {
        Spacer()
        InfoPopoverItem(infoText: "Das ist eine Information", showPopover: .constant(true))
    }
}
