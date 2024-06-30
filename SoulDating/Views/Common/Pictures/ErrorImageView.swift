//
//  ErrorImageView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 19.06.24.
//

import SwiftUI

struct ErrorImageView: View {
    let systemName: String
    let size: CGFloat
    @Binding var isLoaded: Bool
    var body: some View {
        Image(systemName: systemName)
            .font(.system(size: size))
            .onAppear {
                isLoaded = false
            }
        
    }
}

#Preview {
    ErrorImageView(systemName: "wifi.slash", size: CGFloat(100), isLoaded: .constant(false))
}
