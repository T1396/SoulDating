//
//  OnboardingPictureView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 11.06.24.
//

import SwiftUI
import PhotosUI

struct OnboardingPictureView: View {
    
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var selectedPhotoItem: PhotosPickerItem?
    
    // MARK: computed properties
    var buttonBackground: Color {
        viewModel.imageData != nil ? .accentColor : .gray.opacity(0.7)
    }
    
    var body: some View {
        VStack {
            Text("Lade ein Profilbild hoch")
                .font(.headline)
                .padding()
            
            if let imageData = viewModel.imageData, let uiImage = UIImage(data: imageData) {
                RoundedImageView(uiImage: uiImage, width: 300, height: 300)
            } else {
                PhotosPicker(
                    selection: $selectedPhotoItem,
                    matching: .images,
                    photoLibrary: .shared()) {
                        Label("Bild auswählen", systemImage: "photo.on.rectangle")
                            .labelStyle(.titleAndIcon)
                            .padding()
                    }
                    .onChange(of: selectedPhotoItem) { oldValue, newValue in
                        guard let newValue else { return }
                        Task {
                            if let data = try? await newValue.loadTransferable(type: Data.self) {
                                viewModel.imageData = data
                            }
                        }
                    }
            }
            Spacer()
            
            
            NavigationLink(destination: OnboardingLocationView(viewModel: viewModel)) {
                Text("Weiter")
                    .textButtonStyle(color: buttonBackground)
            }
            .disabled(viewModel.imageData == nil)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .navigationTitle("Profilbild")
        .padding()
    }
}

#Preview {
    OnboardingPictureView(viewModel: OnboardingViewModel())
}
