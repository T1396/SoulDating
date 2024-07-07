//
//  LoadingView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 05.07.24.
//

import SwiftUI

struct LoadingView: View {
    var message: String
    var body: some View {
        VStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .frame(width: 50, height: 50)

            Text(message)
                .appFont(size: 18, textWeight: .bold)
                .multilineTextAlignment(.center)

        }
    }
}

#Preview {
    LoadingView(message: "ldsöa")
}
