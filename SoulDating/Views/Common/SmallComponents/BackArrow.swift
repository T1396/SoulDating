//
//  BackArrow.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 16.06.24.
//

import SwiftUI

struct BackArrow: View {
    var text: String = Strings.back
    var showLabel: Bool = true
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "chevron.left")
                    .fontWeight(.bold)
                if showLabel {
                    Text(text)
                        .offset(x: -6)
                }
            }
            .padding()
            .contentShape(Rectangle())
        }
    }
}

#Preview {
    BackArrow(text: "Back", action: {})
}
