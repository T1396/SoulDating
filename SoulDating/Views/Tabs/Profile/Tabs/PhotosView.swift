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
    enum AddPhotoOption { case camera, library }
    @State private var addPhotoOption: AddPhotoOption = .library
    @State private var showPhotoOptionSheet = false
    @State private var showImagePicker = false
    @StateObject private var profileViewModel = ProfileViewModel()
    @Environment(\.editMode) var editMode
    
    private let gridItems = Array(repeating: GridItem(.flexible()), count: 3)
    
    @State var images = [
        SortedImage(imageUrl: "https://firebasestorage.googleapis.com:443/v0/b/souldating-b6486.appspot.com/o/profileImages%2FFW4oOlh92QUyzxUd8reUoYVSBfn2%2F8E55C58C-C011-4A27-B64F-78FDF5921167.jpg?alt=media&token=ad2b148f-3685-40e3-a28a-fbbe7ad2495e", position: 1),
        SortedImage(imageUrl: "https://firebasestorage.googleapis.com:443/v0/b/souldating-b6486.appspot.com/o/profileImages%2FY2PNqReH9YQsKIMnsxnwDZ23L6m1%2F93E6AAB6-631B-4737-863E-B9228076E66F.jpg?alt=media&token=a62885fc-2f79-4b6c-aef7-601a8c86ba3f", position: 2),
        SortedImage(imageUrl: "https://firebasestorage.googleapis.com:443/v0/b/souldating-b6486.appspot.com/o/profileImages%2FHQKJq4QlHiRIf1kF4QAv5qad0F73%2FotherImages%2F6C6AE870-FD99-460E-8D36-7E066367CE3B.jpg?alt=media&token=2156c595-6a34-4a5f-8464-065d9bb177a4", position: 3)
    ]
    
    
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
                            .confirmationDialog("Choose an option to upload a photo", isPresented: $showPhotoOptionSheet, titleVisibility: .visible) {
                                imageSelectionOptions
                            }
                        
                        // Reorderable For Each for drop/move functionality
                        ReorderableForEach(items: profileViewModel.userImages) { item in
                            UserImage(url: item.imageUrl, minWidth: width, minHeight: height)
                                .imageStrokeStyle()
                            
                                // sets preview shapes
                                .contentShape(.dragPreview, RoundedRectangle(cornerRadius: 12, style: .continuous))
                                .contentShape(.contextMenuPreview, RoundedRectangle(cornerRadius: 12, style: .continuous))
                            
                                .contextMenu {
                                    PhotosContextOptions(image: item)
                                }
                        } moveAction: { from, to in
                            profileViewModel.userImages.move(fromOffsets: from, toOffset: to)
                            // profileViewModel.updateImageOrderInFirestore()
                        }
                    }
                    .padding([.horizontal, .top])
                }
                .background(Color(.systemGroupedBackground))
            }
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
                Label("Camera", systemImage: "camera.viewfinder")
            }
            
            Button {
                addPhotoOption = .library
                showImagePicker = true
            } label: {
                Label("Library", systemImage: "photo.stack")
            }
        }
    }
    
    private func selectedPhotoOption() -> some View {
        switch addPhotoOption {
        case .camera:
            SUImagePickerView(sourceType: .camera, image: $profileViewModel.selectedImage, isPresented: $showImagePicker)
        case .library:
            SUImagePickerView(sourceType: .photoLibrary, image: $profileViewModel.selectedImage, isPresented: $showImagePicker)
        }
    }
}



/** Credits https://stackoverflow.com/questions/62606907/swiftui-using-ondrag-and-ondrop-to-reorder-items-within-one-single-lazygrid */
struct ReorderableForEach<Content: View, Item: Identifiable & Equatable>: View {
    let items: [Item]
    let content: (Item) -> Content
    let cornerRadius: CGFloat
    let moveAction: (IndexSet, Int) -> Void
    
    // A little hack that is needed in order to make view back opaque
    // if the drag and drop hasn't ever changed the position
    // Without this hack the item remains semi-transparent
    @State private var hasChangedLocation: Bool = false
    
    init(
        items: [Item],
        cornerRadius: CGFloat = 12,
        @ViewBuilder content: @escaping (Item) -> Content,
        moveAction: @escaping (IndexSet, Int) -> Void
    ) {
        self.items = items
        self.cornerRadius = cornerRadius
        self.content = content
        self.moveAction = moveAction
    }
    
    @State private var draggingItem: Item?
    
    var body: some View {
        ForEach(items) { item in
            content(item)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(isDragging(item) ? .white.opacity(0.8) : .clear)
                )
                .onDrag {
                    draggingItem = item
                    return NSItemProvider(object: "\(item.id)" as NSString)
                }
                .onDrop(
                    of: [UTType.text],
                    delegate: DragRelocateDelegate(
                        item: item,
                        listData: items,
                        current: $draggingItem,
                        hasChangedLocation: $hasChangedLocation
                    ) { from, to in
                        withAnimation {
                            moveAction(from, to)
                        }
                    }
                )
        }
    }
    
    private func isDragging(_ item: Item) -> Bool {
        draggingItem == item && hasChangedLocation
    }
}

struct DragRelocateDelegate<Item: Equatable>: DropDelegate {
    let item: Item
    var listData: [Item]
    @Binding var current: Item?
    @Binding var hasChangedLocation: Bool
    
    var moveAction: (IndexSet, Int) -> Void
    
    func dropEntered(info: DropInfo) {
        guard item != current, let current = current else { return }
        guard let from = listData.firstIndex(of: current), let to = listData.firstIndex(of: item) else { return }
        
        hasChangedLocation = true
        
        if listData[to] != current {
            moveAction(IndexSet(integer: from), to > from ? to + 1 : to)
        }
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        DropProposal(operation: .move)
    }
    
    func performDrop(info: DropInfo) -> Bool {
        hasChangedLocation = false
        current = nil
        return true
    }
}

#Preview {
    PhotosView()
        .environmentObject(ProfileViewModel())
}
