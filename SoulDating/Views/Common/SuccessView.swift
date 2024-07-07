//
//  SuccessButton.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 05.07.24.
//

import SwiftUI

struct SuccessView: View {
    let message: String
    var body: some View {
        VStack {
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundStyle(.green)
                .transition(.scale)

            Text(message)
                .appFont(size: 18, textWeight: .bold)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    SuccessView(message: "dkals")
}
