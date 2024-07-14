//
//  SwipeGestureExtension.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 14.06.24.
//

import Foundation
import SwiftUI

extension View {
    func swipeGesture(
        dragAmount: Binding<CGSize>,
        treshold: CGFloat = 100,
        verticalTreshold: CGFloat = 300,
        maxRotation: Double = 15,
        overlayRadius: Int = 25,
        user: FireUser,
        onSwipe: @escaping (SwipeAction, FireUser) -> Void
    ) -> some View {


        self
            .overlay(
                Rectangle()
                    .fill(
                        // Check if vertical (upward) swipe dominates over horizontal swipe
                        abs(dragAmount.wrappedValue.height) > abs(dragAmount.wrappedValue.width) && dragAmount.wrappedValue.height < 0 ?
                            .superLike.opacity(Double(-dragAmount.wrappedValue.height / 500)) :
                            // Check if right swipe
                        dragAmount.wrappedValue.width > 0 ?
                        Color.green.opacity(Double(dragAmount.wrappedValue.width / 300)) :
                            // Check if left swipe
                        dragAmount.wrappedValue.width < 0 ?
                        Color.red.opacity(Double(-dragAmount.wrappedValue.width / 300)) :
                            Color.clear
                    )
                    .clipShape(RoundedRectangle(cornerRadius: CGFloat(overlayRadius)))
            )
            .rotationEffect(dragAmount.wrappedValue.rotationAngle(for: maxRotation))
            .offset(dragAmount.wrappedValue)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        dragAmount.wrappedValue = value.translation
                    }
                    .onEnded { value in

                        if abs(value.translation.width) > treshold || abs(value.translation.height) > verticalTreshold {
                            let action = SwipeAction.fromSwipe(dragAmount: value.translation)
                            if let action {
                                let finalHorizontalOffset = 600 * (value.translation.width > 0 ? 1 : -1)
                                let finalVerticalOffset = value.translation.height < -verticalTreshold ? -500 : 0

                                withAnimation(.easeOut(duration: 0.6)) {
                                    if action == .like || action == .dislike {
                                        dragAmount.wrappedValue.width = CGFloat(finalHorizontalOffset)
                                        dragAmount.wrappedValue.height = CGFloat(finalVerticalOffset)
                                    } else {
                                        // when superliked let item drag out at top
                                        dragAmount.wrappedValue.height = CGFloat(-800)
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        // will remove the swiped card from the ui so id doesnt sits in nowhere
                                        onSwipe(action, user)
                                    }
                                }
                            } else {
                                withAnimation(.spring()) {
                                    dragAmount.wrappedValue = .zero
                                }
                            }
                        } else {
                            withAnimation(.spring()) {
                                dragAmount.wrappedValue = .zero
                            }
                        }
                    }
            )
    }
}

/// returns a rotation angle depending on the actual position of an element
extension CGSize {
    func rotationAngle(for maxRotation: Double) -> Angle {
        let rotation = Double(-self.width / 20)
        return Angle(degrees: max(-maxRotation, min(maxRotation, rotation)))
    }
}


#Preview {
    @State var dragAmount: CGSize = .zero
    @State var user: FireUser = .init(id: "-1")
    return VStack {
        Image("profileimage")
            .resizable()
            .scaledToFit()
    }
    .swipeGesture(dragAmount: $dragAmount, user: user, onSwipe: { _, _ in })
}
