//
//  OnboardingPictureView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 11.06.24.
//

import SwiftUI
import PhotosUI

extension UIImage {
    func applyTransformations(viewportSize: CGSize, scale: CGFloat, rotation: Angle, translation: CGSize) -> UIImage? {
        let newScale = scale * min(viewportSize.width / size.width, viewportSize.height / size.height)

        UIGraphicsBeginImageContextWithOptions(viewportSize, true, self.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }

        context.translateBy(x: viewportSize.width / 2 + translation.width, y: viewportSize.height / 2 + translation.height)
        context.scaleBy(x: newScale, y: newScale)
        context.rotate(by: CGFloat(rotation.radians))
        context.translateBy(x: -size.width / 2, y: -size.height / 2)

        self.draw(at: CGPoint.zero)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}

struct OnboardingPictureView: View {
    // MARK: properties
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var isImagePickerPresented = false
    @State private var shouldNavigate = false
    
    @GestureState private var dragState = CGSize.zero
    @State private var position = CGSize.zero
    @GestureState private var magnification: CGFloat = 1.0
    @State private var scale: CGFloat = 1.0
    @State private var rotation: Angle = .zero
    
    @State private var rectangleWidth: CGFloat = 0
    @State private var rectangleHeight: CGFloat = 0
    // MARK: computed properties
    var pickerLabelText: String {
        viewModel.imageData == nil ? "Choose picture" : "Update Picture"
    }
    
    var dragGesture: some Gesture {
        DragGesture()
            .updating($dragState) { drag, state, transaction in
                state = drag.translation
            }
            .onEnded { drag in
                self.position.width += drag.translation.width
                self.position.height += drag.translation.height
            }
    }
    
    var magnificationGesture: some Gesture {
        MagnificationGesture()
            .updating($magnification) { value, state, _ in
                state = value
            }
            .onEnded { value in
                self.scale = max(1.0, self.scale * value)
            }
    }
    
    var combinesGesture: some Gesture {
        dragGesture.simultaneously(with: magnificationGesture)
    }
    
    var body: some View {
        VStack {
            VStack {
                Text("Upload Picture")
                    .font(.custom("Montserrat-Bold", size: 32))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Your image should nearly fit in this rectangle")
                    .font(.custom("Montserrat-Light", size: 14))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 2)
            }
            .padding(.horizontal)
            
            
            GeometryReader { geometry in
                ZStack(alignment: .bottom) {
                    
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(lineWidth: 2)
                        .foregroundStyle(.blue)
                        .onAppear {
                            rectangleWidth = geometry.size.width
                            rectangleHeight = geometry.size.height
                        }
                    
                    if let imageData = viewModel.imageData, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .scaleEffect(magnification * scale)
                            .rotationEffect(rotation)
                            .offset(x: position.width + dragState.width, y: position.height + dragState.height)
                            .frame(width: geometry.size.width - geometry.safeAreaInsets.leading - geometry.safeAreaInsets.trailing, height: geometry.size.height)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .gesture(combinesGesture)
                            .padding(2)

                        //RoundedImageView(uiImage: uiImage, width: 300, height: 300)
                        
                    }
                    Button {
                        withAnimation {
                            self.rotation -= .degrees(90)
                        }
                    } label: {
                        Image(systemName: "rotate.left.fill")
                            .font(.title)
                            .padding()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    
                    PhotosPicker(
                        selection: $selectedPhotoItem,
                        matching: .images,
                        photoLibrary: .shared()) {
                            Label(pickerLabelText, systemImage: "photo.on.rectangle")
                                .labelStyle(.titleAndIcon)
                                .foregroundStyle(.black)
                                .appButtonStyle()
                                .tint(.black)
                        }
                        .onChange(of: selectedPhotoItem) { oldValue, newValue in
                            guard let newValue else { return }
                            Task {
                                if let data = try? await newValue.loadTransferable(type: Data.self) {
                                    viewModel.imageData = data
                                }
                            }
                        }
                        .padding(.bottom)
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            Button {
                saveEditedImage()
                shouldNavigate = true
            } label: {
                Text("Continue")
            }
            .appButtonStyle(fullWidth: true)
            .padding()
            .disabled(viewModel.imageData == nil)
            
        }
        .navigationDestination(isPresented: $shouldNavigate) {
            OnboardingNotificationView(viewModel: viewModel)
        }
        .navigationTitle("Profilbild")
    }
    
    func saveEditedImage() {
        if let imageData = viewModel.imageData, let uiImage = UIImage(data: imageData) {
            let targetSize = CGSize(width: rectangleWidth, height: rectangleHeight - 125)

            let image = uiImage.applyTransformations(viewportSize: targetSize, scale: scale * magnification, rotation: rotation, translation: CGSize(width: position.width, height: position.height))
            if let newData = image?.jpegData(compressionQuality: 0.8) {
                viewModel.imageData = newData
            }
        }
    }

}

#Preview {
    OnboardingPictureView(viewModel: OnboardingViewModel())
}
