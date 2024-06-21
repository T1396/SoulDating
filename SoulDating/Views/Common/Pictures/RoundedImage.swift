//
//  RoundedImage.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 14.06.24.
//

import SwiftUI

struct RoundedImage: View {
    var uiImage: UIImage = UIImage(named: "profileimage") ?? UIImage()
    var progress: Double = 0
    var width: Int = 200
    var height: Int = 200
    var cornerRadius: Int = 14
    
    var body: some View {
        Image(uiImage: uiImage)
            .resizable()
            .scaledToFit()
            .clipShape(RoundedRectangle(cornerRadius: CGFloat(cornerRadius)))
            .frame(width: CGFloat(width), height: CGFloat(height))
    }
}

#Preview {
    RoundedImage()
}
