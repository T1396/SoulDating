//
//  PhotosView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 20.06.24.
//

import SwiftUI
import PhotosUI
import Foundation



struct PhotosView: View {
    // MARK: properties
    enum AddPhotoOption { case camera, library }
    @ObservedObject var imagesVm: ImagesViewModel

    @State private var addPhotoOption: AddPhotoOption = .library
    @State private var showPhotoOptionSheet = false
    @State private var showImagePicker = false
    @State private var active: SortedImage?
    private let gridItems = Array(repeating: GridItem(.flexible()), count: 3)


    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                let width = (geometry.size.width - 40 - 40) / 3
                let height = width * 4.6 / 3


                ScrollView {
                    LazyVGrid(columns: gridItems) {

                        addPhotoItem(width: width, height: height)
                            .sheet(isPresented: $showImagePicker, content: {
                                selectedPhotoOption()
                            })
                            .confirmationDialog(Strings.chooseUploadMethod, isPresented: $showPhotoOptionSheet, titleVisibility: .visible) {
                                imageSelectionOptions
                            }


                        ReorderableForEach(imagesVm.userImages, active: $active) { item in
                            UserImage(url: item.imageUrl, minWidth: width, minHeight: height)
                                .imageStrokeStyle()

                                .contextMenu {
                                    PhotosContextOptions(image: item)
                                }
                            // sets preview shapes
                                //.contentShape(.dragPreview, RoundedRectangle(cornerRadius: 12, style: .continuous))
                                .contentShape(.contextMenuPreview, RoundedRectangle(cornerRadius: 12, style: .continuous))
                        } preview: { item in
                            UserImage(url: item.imageUrl, minWidth: width, minHeight: height)
                                .imageStrokeStyle()
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        } moveAction: { from, to in
                            imagesVm.userImages.move(fromOffsets: from, toOffset: to)
                        }
                    }
                    .padding([.horizontal, .top])
                }
                .scrollContentBackground(.hidden)
                .background(Color(.systemGroupedBackground))
            }
            .reorderableForEachContainer(active: $active)

        }
    }

    /// first element in the grid layout to add a new picture
    private func addPhotoItem(width: CGFloat, height: CGFloat) -> some View {
        Button(action: {
            showPhotoOptionSheet = true
        }, label: {
            VStack {
                Image(systemName: "plus")
                    .font(.largeTitle)
                    .foregroundColor(.accent)
            }
            .frame(width: width, height: height)
            .background(.accent.quinary)
            .imageStrokeStyle()
        })
    }

    var imageSelectionOptions: some View {
        Group {
            Button {
                addPhotoOption = .camera
                showImagePicker = true
            } label: {
                Label(Strings.camera, systemImage: "camera.viewfinder")
            }

            Button {
                addPhotoOption = .library
                showImagePicker = true
            } label: {
                Label(Strings.library, systemImage: "photo.stack")
            }
        }
    }

    private func selectedPhotoOption() -> some View {
        switch addPhotoOption {
        case .camera:
            SUImagePickerView(sourceType: .camera, image: $imagesVm.selectedImage, isPresented: $showImagePicker)
        case .library:
            SUImagePickerView(sourceType: .photoLibrary, image: $imagesVm.selectedImage, isPresented: $showImagePicker)
        }
    }
}


#Preview {
    PhotosView(imagesVm: ImagesViewModel())
}
