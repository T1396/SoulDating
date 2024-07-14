//
//  ImageSelectionGrid.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 11.07.24.
//

import SwiftUI

struct ImageSelectionGrid: View {
    private let gridItems = Array(repeating: GridItem(.flexible()), count: 3)
    @ObservedObject var imagesVm: ImagesViewModel

    @Binding var newMainPicture: String?
    @Binding var activeTab: ProfileTab

    var onToggleOverlay: () -> Void

    var body: some View {
        GeometryReader { geometry in
            if imagesVm.userImagesWithoutMainPic.isEmpty {
                VStack {
                    Text(Strings.noOtherImages)
                        .multilineTextAlignment(.center)
                        .appFont(size: 20, textWeight: .bold)

                    Button {
                        onToggleOverlay()
                        activeTab = .fotos
                    } label: {
                        Text(Strings.goToPhotosTab)
                            .appButtonStyle()
                    }
                }
                .frame(maxHeight: .infinity)
                .padding()
            } else {
                LazyVGrid(columns: gridItems, content: {

                    ForEach(imagesVm.userImagesWithoutMainPic) { image in
                        ZStack {
                            Button {
                                if newMainPicture == image.imageUrl {
                                    newMainPicture = nil
                                } else {
                                    newMainPicture = image.imageUrl
                                }
                            } label: {
                                UserImage(url: image.imageUrl, minWidth: geometry.size.width / 3 - 16, minHeight: geometry.size.width / 2.4 - 16)
                                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                    .padding(4)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .fill(.thickMaterial)
                                    )
                            }

                            if newMainPicture == image.imageUrl {
                                Image(systemName: "checkmark.circle.fill")
                                    .padding(6)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                            }
                        }
                    }
                })
                .padding(8)
            }
        }
    }
}

#Preview {
    ImageSelectionGrid(imagesVm: ImagesViewModel(), newMainPicture: .constant(nil), activeTab: .constant(.aboutyou), onToggleOverlay: {})
}
