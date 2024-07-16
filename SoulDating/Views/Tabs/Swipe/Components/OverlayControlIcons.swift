//
//  OverlayControlIcons.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 03.07.24.
//

import SwiftUI

struct OverlayControlIcons: View {
    // MARK: properties
    var alreadyInteracted: Bool

    var onDislike: () -> Void
    var onMessage: () -> Void
    var onLike: () -> Void

    // MARK: computed properties
    var likeDislikeColor: Color {
        alreadyInteracted ? .gray : .red
    }

    // MARK: body
    var body: some View {
        HStack(spacing: 30) {
            controlIcon("xmark.circle.fill", color: likeDislikeColor, disabled: alreadyInteracted) {
                withAnimation {
                    onDislike()
                }
            }
            controlIcon("message.fill", color: .green, disabled: false) {
                onMessage()
            }
            controlIcon("heart.fill", color: likeDislikeColor, disabled: alreadyInteracted) {
                onLike()
            }
        }
        .padding(.bottom)
    }

    private func controlIcon(_ systemName: String, color: Color, disabled: Bool, action: @escaping() -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.title)
                .foregroundStyle(color)
                .padding()
                .background()
                .clipShape(Circle())
        }
        .disabled(disabled)
    }
}

#Preview {
    OverlayControlIcons(alreadyInteracted: false, onDislike: {}, onMessage: {}, onLike: {})
}
