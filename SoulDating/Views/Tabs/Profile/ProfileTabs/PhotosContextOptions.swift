//
//  PhotosContextOptions.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 25.06.24.
//

import SwiftUI

struct PhotosContextOptions: View {
    // MARK: properties
    @ObservedObject var imagesVm: ImagesViewModel
    var image: SortedImage

    init(imagesVm: ImagesViewModel, image: SortedImage) {
        self.imagesVm = imagesVm
        self.image = image
        print("context init")
    }

    var body: some View {
        ControlGroup {
            Button(action: shareImage) {
                Label(Strings.share, systemImage: "square.and.arrow.up")
            }
            
            Button(action: downloadImage) {
                Label(Strings.download, systemImage: "arrow.down.doc")
            }

            Button(role: .destructive, action: deleteImage) {
                Label(Strings.delete, systemImage: "trash.fill")
            }
            .disabled(imagesVm.mainImageUrl == image.imageUrl)
        }
        Button(Strings.moveFirst) {
            imagesVm.moveImageToFirst(image: image)
        }
        Button(Strings.moveLast) {
            imagesVm.moveImageToLast(image: image)
        }
        Button(Strings.selectAsPicture) {
            imagesVm.updateMainPicture(newPicture: image.imageUrl)
        }
        .disabled(imagesVm.mainImageUrl == image.imageUrl)

    }
    
    private func shareImage() {
        
    }
    
    private func downloadImage() {
        Task {
            await imagesVm.downloadAndSaveImage(from: image.imageUrl)
        }
    }
    
    private func deleteImage() {
        withAnimation {
            imagesVm.deleteImage(imageId: image.id)
        }
    }
}

#Preview {
    PhotosContextOptions(imagesVm: ImagesViewModel(), image: SortedImage(imageUrl: "dklsa", position: 1))
}
