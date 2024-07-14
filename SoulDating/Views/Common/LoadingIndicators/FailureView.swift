//
//  FailureView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 06.07.24.
//

import SwiftUI

struct FailureView: View {
    var message: String

    var body: some View {
        VStack {
            Image(systemName: "xmark.circle.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.red)
                .transition(.scale)

            Text(message)
                .appFont(size: 18, textWeight: .bold)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    FailureView(message: "failed to report")
}
