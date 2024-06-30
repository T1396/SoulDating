//
//  PhotosContextOptions.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 25.06.24.
//

import SwiftUI

struct PhotosContextOptions: View {
    @EnvironmentObject var profileViewModel: ProfileViewModel
    let image: SortedImage
    var body: some View {
        ControlGroup {
            Button(action: shareImage) {
                Label("Share", systemImage: "square.and.arrow.up")
            }
            
            Button(action: downloadImage) {
                Label("Download", systemImage: "arrow.down.doc")
            }
            
            Button(role: .destructive, action: deleteImage) {
                Label("Delete", systemImage: "trash.fill")
            }
        }
        Button("Move to first position") {
            
        }
        Button("Move to last position") {
            
        }
        Button("Select as display picture") {
            
        }

    }
    
    private func shareImage() {
        
    }
    
    private func downloadImage() {
        Task {
            await profileViewModel.downloadAndSaveImage(from: image.imageUrl)
        }
    }
    
    private func deleteImage() {
        withAnimation {
            profileViewModel.deleteImage(imageId: image.id)
        }
    }
}

#Preview {
    PhotosContextOptions(image: SortedImage(imageUrl: "dklsa", position: 1))
}
