//
//  PhotosContextOptions.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 25.06.24.
//

import SwiftUI

struct PhotosContextOptions: View {
    // MARK: properties
    @EnvironmentObject var imagesVm: ImagesViewModel
    let image: SortedImage

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
        }
        Button(Strings.moveFirst) {

        }
        Button(Strings.moveLast) {

        }
        Button(Strings.selectAsPicture) {
            imagesVm.updateMainPicture(newPicture: image.imageUrl)
        }

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
    PhotosContextOptions(image: SortedImage(imageUrl: "dklsa", position: 1))
}
