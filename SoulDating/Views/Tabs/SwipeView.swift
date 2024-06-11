//
//  SwipeView.swift
//  
//
//  Created by Philipp Tiropoulos on 10.06.24.
//
import SwiftUI

struct SwipeView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @StateObject private var swipeViewModel = SwipeViewModel()

    @State private var dragAmount = CGSize.zero

    private let treshold: CGFloat = 100
    private let maxRotation: Double = 15 // max rotation angle

    var colorOverlay: Color {
        if dragAmount.width > 0 {
            // green color for right swipe
            return .green.opacity(Double(dragAmount.width / 300))
        } else {
            return .red.opacity(Double(-dragAmount.width / 300))
        }
    }

    var rotationAngle: Angle {
        let amount = Double(-dragAmount.width / 20)
        return Angle(degrees: max(-maxRotation, min(maxRotation, amount)))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                GeometryReader { geometry in
                    ZStack(alignment: .bottom) {
                        Image("sampleimage")
                            .resizable()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .overlay(
                                Rectangle()
                                    .foregroundStyle(colorOverlay)
                                    .blendMode(.normal)

                            )
                            .clipShape(RoundedRectangle(cornerRadius: 14))

                        HStack(spacing: 30) {
                            controlIcon("xmark.circle.fill", color: .red)
                            controlIcon("message.fill", color: .green)
                            controlIcon("heart.fill", color: .red)
                        }
                        .padding(.bottom)
                    }
                    .rotationEffect(rotationAngle)
                    .offset(dragAmount)
                    .gesture(
                        DragGesture()
                            .onChanged { dragAmount = $0.translation }
                            .onEnded { value in
                                if abs(value.translation.width) > treshold {
                                    withAnimation(.easeOut(duration: 2.0)) {
                                        dragAmount.width = 1000 * (value.translation.width > 0 ? 1 : -1)
                                        dragAmount.height = 500
                                    }
                                    // MARK: TODO
                                    // show next user
                                } else {
                                    withAnimation(.spring()) {

                                        dragAmount = .zero
                                    }
                                }
                            }
                    )
                }
            }
            .padding()
            .clipped()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem {
                    Button(action: { dragAmount = .zero }) {
                        Image(systemName: "arrowshape.turn.up.backward.fill")
                    }
                }
            }
            .onAppear {
                //swipeViewModel.configure(with: userViewModel)
            }
        }
    }


    @ViewBuilder
    func controlIcon(_ systemName: String, color: Color) -> some View {
        Image(systemName: systemName)
            .font(.title)
            .foregroundStyle(color)
            .padding()
            .background()
            .clipShape(Circle())
    }
}

#Preview {
    SwipeView()
}
