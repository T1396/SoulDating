//
//  ProfileViewModel.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 21.06.24.
//

import Foundation
import SwiftUI
import Photos
import Firebase



class ImagesViewModel: BaseAlertViewModel {
    // MARK: properties
    private let firebaseManager = FirebaseManager.shared
    private let userService: UserService
    @Published var selectedImage: UIImage? {
        didSet {
            if selectedImage != nil {
                overlayMessage = "Image is beeing uploaded..."
                uploadImage()
            }
        }
    }

    private var initialUserImages: [SortedImage] = []

    @Published private (set) var userImages: [SortedImage] = []
    @Published private (set) var mainImageUrl: String?

    // MARK: init
    init(userService: UserService = .shared) {
        self.userService = userService
        self.mainImageUrl = userService.user.profileImageUrl
        super.init()
        fetchUserImages()
    }

    // MARK: computed properties
    var user: FireUser {
        userService.user
    }

    /// all user images without the main display picture
    var userImagesWithoutMainPic: [SortedImage] {
        userImages.filter { $0.imageUrl != userService.user.profileImageUrl }
    }


    // MARK: functions
    /// creates and returns a sorted image from a urlstring of an uploaded image
    private func createSortedImage(urlString: String) -> SortedImage {
        let newImage = SortedImage(imageUrl: urlString, position: userImages.count)
        return newImage
    }

    /// appends an uploaded image to the userImages list and returns a copy of the updated list
    /// - Parameter urlString: string of the image url
    /// - Returns: a tuple containing the updated list  and the position of the image in the list
    private func getUpdatedImageList(urlString: String) -> ([SortedImage], Int) {
        var newImages = userImages
        let image = SortedImage(imageUrl: urlString, position: newImages.count)
        newImages.append(image)
        return (newImages, newImages.count - 1)
    }


    private func createGenericAlert() {
        createAlert(title: "Error", message: Strings.unexpectedErrorOccured)
    }
}

// MARK: FETCH IMAGES
extension ImagesViewModel {
    private func fetchUserImages() {
        guard let userId = firebaseManager.userId else { return }

        firebaseManager.database.collection("userImages").document(userId)
            .getDocument { document, error in
                if let error {
                    self.createGenericAlert()
                    print("Error while fetching user images from firestore", error.localizedDescription)
                    return
                }

                if let data = document?.data(), let imagesData = data["images"] as? [[String: Any]] {
                    let images = imagesData.compactMap { SortedImage(dictionary: $0) }
                    print("Mapped Images: \(images)")
                    self.userImages = images.sorted(by: { $0.position < $1.position })
                    self.initialUserImages = self.userImages
                }
            }
    }
}

// MARK: UPLOAD IMAGE
extension ImagesViewModel {
    /// updates a selected image to fire storage and if succeeded, updates userImages document with the uploaded image URL
    func uploadImage() {
        guard let userId = firebaseManager.userId else { return }
        uploadImageToStorage(for: userId) { result in
            switch result {
            case .success(let success):
                let newImage = self.createSortedImage(urlString: success.absoluteString)
                self.insertImageIntoDocument(for: userId, with: newImage)
            case .failure(let failure):
                print(failure)
                let errorMessage = (failure as? FirebaseError)?.displayMessage ?? Strings.unexpectedErrorOccured
                self.createAlert(title: "Error", message: errorMessage)
            }
            // disables overlay notification
            self.overlayMessage = nil
        }
    }
    /// Uploads the selected image into firebase storage and calls the closure when completed with the result
    private func uploadImageToStorage(for userId: String, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let selectedImage else {
            completion(.failure(FirebaseError.nopicturechosen))
            return
        }
        guard let imageData = selectedImage.jpegData(compressionQuality: 1.0) else {
            completion(.failure(FirebaseError.convertError))
            return
        }
        let filename = UUID().uuidString + ".jpg"
        let userRef = firebaseManager.storage.reference().child("profileImages/\(userId)/otherImages/\(filename)")
        userRef.putData(imageData, metadata: nil) { _, error in
            if let error {
                completion(.failure(error))
                return
            }
            userRef.downloadURL { url, error in
                if let url {
                    completion(.success(url))
                } else {
                    completion(.failure(error ?? FirebaseError.downloadUrlFailure))
                }
            }
        }
    }
}

// MARK: MOVE IMAGES
extension ImagesViewModel {
    func moveImage(fromIndex: IndexSet, toIndex: Int) {
        userImages.move(fromOffsets: fromIndex, toOffset: toIndex)
    }

    func moveImageToFirst(image: SortedImage) {
        guard let index = userImages.firstIndex(where: { $0.id == image.id }) else { return }
        userImages.remove(at: index)
        userImages.insert(image, at: 0)
    }

    func moveImageToLast(image: SortedImage) {
        guard let index = userImages.firstIndex(where: { $0.id == image.id }) else { return }
        userImages.remove(at: index)
        userImages.append(image)
    }

    /// update the order of images in firestore
    func updateImageOrderInFirestore() {
        // only update if images actually changed
        guard let userId = firebaseManager.userId, userImages != initialUserImages else { return }
        let images = userImages
        let data = images.enumerated().map { $1.toDict(pos: $0) } // $0 == index, $1 == image
        let docRef = firebaseManager.database.collection("userImages").document(userId)
        docRef.updateData(["images": data]) { error in
            if let error {
                print("error updating other images in user doc", error.localizedDescription)
                return
            }
            print("other images successfully updated\n")
        }
    }
}

// MARK: UPDATE IMAGE DOCUMENTS
extension ImagesViewModel {
    /// updates the main profile picture  urlof a user with another existing picture url
    func updateMainPicture(newPicture: String?) {
        guard let userId = firebaseManager.userId, let newPicture else { return }
        firebaseManager.database.collection("users").document(userId)
            .updateData(["profileImageUrl": newPicture]) { error in
                if let error {
                    print("Failed to update main profile picture in firestore", error.localizedDescription)
                    return
                }

                // update value locally
                self.userService.user.profileImageUrl = newPicture
                self.mainImageUrl = newPicture
                print("Successfully updated image to firestore")
            }
    }

    /// removes an image from the userImages document and removed the image from the 'userImages' Published list for UI update
    private func removeImageFromDocument(userId: String, removedImageId: String) {
        let docRef = firebaseManager.database.collection("userImages").document(userId)
        // local copy so the UI-list won't get updated until the changes were successfully
        var newImages = userImages
        if let index = newImages.firstIndex(where: { $0.id == removedImageId }) {
            newImages.remove(at: index)

            let imagesData = newImages.map { $0.toDict(pos: $0.position) }
            docRef.updateData(["images": imagesData]) { error in
                if let error {
                    print("Failed to update user images document", error.localizedDescription)
                    return
                }

                print("Successfully updated user images document (deleted image)")
                // new list with removed image is inserted to firestore so we can remove the image from 'userImages'
                if let index = self.userImages.firstIndex(where: { $0.id == removedImageId }) {
                    self.userImages.remove(at: index)
                }
            }
        }
    }
    /// add a uploaded image with url and position into user images document
    private func insertImageIntoDocument(for userId: String, with newImage: SortedImage) {
        let imageData = newImage.toDict(pos: newImage.position)
        firebaseManager.database.collection("userImages").document(userId)
            .setData(["images": FieldValue.arrayUnion([imageData])], merge: true, completion: { error in
                if let error {
                    print("Failed to add new picture to user images document", error.localizedDescription)
                    self.createAlert(title: Strings.error, message: Strings.saveImageError)
                    return
                }

                print("user images document successfully updated")
                self.userImages.append(newImage)
            })
    }
}

// MARK: DELETE IMAGES
extension ImagesViewModel {
    /// deletes an image from firebase storage and if succeeded, from the user document as well
    func deleteImage(imageId: String) {
        guard let userId = firebaseManager.userId else { return }

        if let index = userImages.firstIndex(where: { $0.id == imageId }) {
            let image = userImages[index]
            deleteImageFromStorage(imageUrl: image.imageUrl) { result in
                switch result {
                case .success:
                    self.removeImageFromDocument(userId: userId, removedImageId: image.id)
                case .failure(let failure):
                    print(failure)
                    self.createAlert(title: Strings.error, message: Strings.deleteImageError)
                }
            }
        }
    }
    /// deletes an image in storage depending on the inserted imageUrl and calls completion closure with the result
    private func deleteImageFromStorage(imageUrl: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let imageRef = firebaseManager.storage.reference(forURL: imageUrl)
        imageRef.delete { error in
            if let error = error {
                print("error while deleting userImage", error.localizedDescription)
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}

// MARK: DOWNLOAD IMAGE
extension ImagesViewModel {
    /// downloads and saves an image into the library of the user
    func downloadAndSaveImage(from imageUrl: String) async {
        do {
            let image = try await downloadImageFromStorage(from: imageUrl)
            try await saveImageToPhotoLibrary(image)
            executeDelayed(completion: {
                self.overlayMessage = "Successfully downloaded image into your library"
            }, delay: 0.2)
        } catch {
            DispatchQueue.main.async {
                self.createAlert(title: Strings.error, message: error.localizedDescription)
            }
        }
    }

    func downloadImageFromStorage(from url: String) async throws -> UIImage {
        let imageRef = firebaseManager.storage.reference(forURL: url)
        let maxDownloadSize: Int64 = 10 * 1024 * 1024 // 10MB
        let data = try await imageRef.data(maxSize: maxDownloadSize)
        guard let image = UIImage(data: data) else {
            throw FirebaseError.convertError
        }
        return image
    }


    private func saveImageToPhotoLibrary(_ image: UIImage) async throws {
        let status = await PHPhotoLibrary.requestAuthorization(for: .addOnly)
        guard status == .authorized else {
            throw NSError(domain: "PhotosAccessDenied", code: 0, userInfo: [NSLocalizedDescriptionKey: "Access to photo library denied"])
        }

        try await PHPhotoLibrary.shared().performChanges {
            PHAssetCreationRequest.creationRequestForAsset(from: image)
        }
    }
}
