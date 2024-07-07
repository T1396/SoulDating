//
//  ErrorImageView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 19.06.24.
//

import SwiftUI


struct PlaceholderImageView: View {
    let systemName: String
    let size: CGFloat
    @Binding var isLoaded: Bool

    var body: some View {
        GeometryReader { geometry in
            Image(systemName: systemName)
                .resizable()
                .scaledToFit()
                .padding(40)
                .frame(width: geometry.size.width, height: geometry.size.height)
                .onAppear {
                    isLoaded = false
                }
        }
    }
}

#Preview {
    PlaceholderImageView(systemName: "wifi.slash", size: CGFloat(100), isLoaded: .constant(false))
        .frame(width: 300, height: 300) // Beispiel für ein festes Rahmenmaß, das dem deiner UserImage entspricht
}
