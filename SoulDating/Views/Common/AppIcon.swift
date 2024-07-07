//
//  AppIcon.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 05.07.24.
//

import SwiftUI

struct AppIcon: View {
    enum Size { case small, large }
    enum Role { case normal, delete }
    let systemName: String
    var size: Size = .large
    var role: Role = .normal

    var font: Font {
        switch size {
        case .small: .caption
        case .large: .title3
        }
    }

    var backgroundColor: Color {
        switch role {
        case .normal: .accent
        case .delete: .red
        }
    }

    var iconBackgroundSize: CGFloat {
        switch size {
        case .small: 20
        case .large: 30
        }
    }

    var body: some View {
        HStack {
            Image(systemName: systemName)
                .font(font)
                .foregroundStyle(.white)
        }
        .frame(width: iconBackgroundSize, height: iconBackgroundSize)
        .padding(2)
        .background(backgroundColor, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}
