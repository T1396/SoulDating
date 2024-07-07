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
        
        var lastUpdateTime = Date()
        var lastPosition = CGSize.zero
        var swipeSpeed: CGFloat = 0
        
        return self
            .overlay(
                Rectangle()
                    .fill(
                        // changes overlay color to green on right and red on left swipe
                        dragAmount.wrappedValue.width > 0 ?
                        Color.green.opacity(Double(dragAmount.wrappedValue.width / 300)) :
                            Color.red.opacity(Double(-dragAmount.wrappedValue.width / 300))
                    )
                    .clipShape(RoundedRectangle(cornerRadius: CGFloat(overlayRadius)))
            )
            .rotationEffect(dragAmount.wrappedValue.rotationAngle(for: maxRotation))
            .offset(dragAmount.wrappedValue)
            .gesture(
                DragGesture()
                    .onChanged {
                        let now = Date()
                        let timeDiff = now.timeIntervalSince(lastUpdateTime)
                        let positionDiff = ($0.translation.width - lastPosition.width)
                        
                        swipeSpeed = abs(positionDiff / CGFloat(timeDiff))
                        lastUpdateTime = now
                        lastPosition = $0.translation
                        
                        dragAmount.wrappedValue = $0.translation
                    }
                    .onEnded { value in
                        let dynamicTreshold = swipeSpeed > 1000 ? treshold * 0.5 : treshold
                        
                        if abs(value.translation.width) > dynamicTreshold
                            || abs(value.translation.height) > verticalTreshold {
                            let action = SwipeAction.fromSwipe(dragAmount: value.translation)
                            if let action {
                                let animation = Animation.easeOut(duration: 0.6)
                                let finalHorizontalOffset = 600 * (value.translation.width > 0 ? 1 : -1)
                                let finalVerticalOffset = value.translation.height < -verticalTreshold ? -500 : 0
                                
                                
                                withAnimation(animation) {
                                    dragAmount.wrappedValue.width = CGFloat(finalHorizontalOffset)
                                    dragAmount.wrappedValue.height = CGFloat(finalVerticalOffset)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
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
