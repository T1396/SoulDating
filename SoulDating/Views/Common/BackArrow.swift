//
//  BackArrow.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 16.06.24.
//

import SwiftUI

struct BackArrow: View {
    var text: String = "Back"
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
        }
    }
}

#Preview {
    BackArrow(text: "Back", action: {})
}
