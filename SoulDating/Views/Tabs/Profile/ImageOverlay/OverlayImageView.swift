//
//  OverlayImageView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 23.06.24.
//

import SwiftUI

struct OverlayImageView: View {
    enum OverlayState { case initial, select, save }

    @ObservedObject var imagesVm: ImagesViewModel
    @Binding var isImagePresented: Bool
    @Binding var loadedImage: Image?
    @Binding var activeTab: ProfileTab

    var width: CGFloat
    var height: CGFloat

    @State private var overlayState: OverlayState = .initial
    @State private var updateEnabled = false
    @State private var newMainPicture: String?

    private let gridItems = Array(repeating: GridItem(.flexible()), count: 3)

    // MARK: computed properties
    var buttonDisabled: Bool {
        overlayState == .select
    }

    var buttonText: String {
        switch overlayState {
        case .initial: Strings.updateMainPic
        case .select: Strings.selectMainPic
        case .save: Strings.save
        }
    }

    var buttonFunction: () -> Void {
        switch overlayState {
        case .initial: openImageSelection
        case .select: {} // not needed
        case .save: setSelectedImage
        }
    }

    // MARK: body
    var body: some View {
        Color.black.opacity(0.4)
            .ignoresSafeArea()
            .zIndex(1)
            .onTapGesture {
                toggleOverlay()
            }

        VStack {
            Group {
                switch overlayState {
                case .initial:
                    userImageView()
                case .select, .save:

                    // imagesGrid
                    ImageSelectionGrid(imagesVm: imagesVm, newMainPicture: $newMainPicture, activeTab: $activeTab, onToggleOverlay: toggleOverlay)
                        .frame(width: width, height: height)
                        .background(
                            RoundedRectangle(cornerRadius: 25, style: .continuous)
                                .fill(.thickMaterial)
                        )
                }
            }
            .onTapGesture {
                toggleOverlay()
            }

            Button(action: buttonFunction, label: {
                Text(buttonText)
                    .appFont(size: 14, textWeight: .bold)
                    .padding()
                    .frame(width: width)
                    .background(buttonDisabled ? Color(red: 0.3, green: 0.3, blue: 0.3) : .accent, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .foregroundStyle(.background.opacity(0.8))
            })
            .disabled(buttonDisabled)
            .zIndex(2)

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onChange(of: newMainPicture, { _, newValue in
            if newValue != nil {
                overlayState = .save
            } else {
                overlayState = .select
            }
        })

        .padding()
        .zIndex(3)
        .shadow(radius: 10)
        .transition(AnyTransition.move(edge: .bottom).combined(with: .opacity))
    }

    // MARK: functions
    private func toggleOverlay() {
        withAnimation(.easeInOut(duration: 0.5)) {
            isImagePresented.toggle()
        }
    }

    private func openImageSelection() {
        withAnimation {
            overlayState = .select
        }
    }

    private func setSelectedImage() {
        withAnimation {
            imagesVm.updateMainPicture(newPicture: newMainPicture)
        }
    }

    // MARK: subviews
    @ViewBuilder
    private func userImageView() -> some View {
        if let loadedImage {
            loadedImage
                .resizable()
                .scaledToFill()
                .frame(width: width, height: height)
                .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                .padding(4)
                .background(
                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .fill(.thickMaterial)
                )
        } else {
            Image(systemName: "photo.fill")
                .font(.system(size: 80))
                .frame(width: width, height: height)
                .padding(4)
                .background(.thickMaterial, in: RoundedRectangle(cornerRadius: 25, style: .continuous))

        }
    }
}

#Preview {
    OverlayImageView(imagesVm: ImagesViewModel(), isImagePresented: .constant(true), loadedImage: .constant(nil), activeTab: .constant(.preferences), width: 100, height: 200)
}
