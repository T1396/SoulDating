//
//  OverlayControlIcons.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 03.07.24.
//

import SwiftUI

struct OverlayControlIcons: View {
    var onDislike: () -> Void
    var onMessage: () -> Void
    var onLike: () -> Void
    var body: some View {
        HStack(spacing: 30) {
            controlIcon("xmark.circle.fill", color: .red) {
                withAnimation {
                    onDislike()
                }
            }
            controlIcon("message.fill", color: .green) {
                onMessage()
            }
            controlIcon("heart.fill", color: .red) {
                onLike()
            }
        }
        .padding(.bottom)
    }
    
    @ViewBuilder
    private func controlIcon(_ systemName: String, color: Color, action: @escaping() -> Void) -> some View {
        Button {
            action()
        } label: {
            Image(systemName: systemName)
                .font(.title)
                .foregroundStyle(color)
                .padding()
                .background()
                .clipShape(Circle())
        }
    }
}

#Preview {
    OverlayControlIcons(onDislike: {}, onMessage: {}, onLike: {})
}
