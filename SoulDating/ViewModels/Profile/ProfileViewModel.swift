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

class ProfileViewModel: BaseAlertViewModel {
    // MARK: properties
    private let firebaseManager = FirebaseManager.shared
    @Published var user: User
    @Published var selectedImage: UIImage? {
        didSet {
            if selectedImage != nil {
                overlayMessage = "Image is beeing uploaded..."
                uploadImage()
            }
        }
    }
    @Published var userImages: [SortedImage] = [] {
        didSet {
            print("Updated User Images: \(userImages)")
        }
    }
    @Published var currentlyDraggingImage: SortedImage = .init(imageUrl: "", position: 0)
    
    // MARK: init
    init(user: User) {
        self.user = user
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdate(_:)), name: .userDocumentUpdated, object: nil)
        fetchUserImages()
    }
    
    
    // MARK: functions
    @objc
    private func didUpdate(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let updatedUser = userInfo["user"] as? User else {
            print("Update user with notification failed")
            return
        }
        print("Updated with user notification successfully")
        self.user = updatedUser
    }
    
    /// updates any user setting in firestore like name, age etc
    /// - Parameters:
    ///    - fieldName: the exact fieldName to update
    ///    - value: the new value which will be inserted to firestore
    /// - value:
    func updateUserField<T: Codable>(_ fieldName: String, with value: T) {
        let db = firebaseManager.database
        db.collection("users").document(user.id).updateData([fieldName: value]) { error in
            if let error = error {
                print("Error updating field \(fieldName): \(error.localizedDescription)")
                self.createAlert(title: "Update error", message: "We couldn't update your profile setting... Please report this as a bug or try again.")
            }
        }
    }
    
    /// creates and returns a sorted image from a urlstring of an uploaded image
    private func getSortedImage(urlString: String) -> SortedImage {
        let newImage = SortedImage(imageUrl: urlString, position: userImages.count)
        return newImage
    }
    
    /// appends an uploaded image to the userImages list and returns a copy of the updated list
    /// - Parameters:
    ///  - urlString: string of the image url
    ///  - Returns: a tuple containing the updated list  and the position of the image in the list
    private func getUpdatedImageList(urlString: String) -> ([SortedImage], Int) {
        var newImages = userImages
        let image = SortedImage(imageUrl: urlString, position: newImages.count)
        newImages.append(image)
        return (newImages, newImages.count - 1)
    }
    
    
    
    private func createGenericAlert() {
        createAlert(title: "Error", message: BaseAlertViewModel.genericErrorMessage)
    }
}

// MARK: ERROR MESSAGE STRINGS
extension BaseAlertViewModel {
    static let genericErrorMessage = "An unexpected error occured, if the issue persists contact us."
}

// MARK: FETCH IMAGES
extension ProfileViewModel {
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
                }
            }
    }
}

// MARK: UPLOAD IMAGE
extension ProfileViewModel {
    /// updates a selected image to fire storage and if succeeded, updates userImages document with the uploaded image URL
    func uploadImage() {
        guard let userId = firebaseManager.userId else { return }
        uploadImageToStorage(for: userId) { result in
            switch result {
            case .success(let success):
                let newImage = self.getSortedImage(urlString: success.absoluteString)
                self.insertImageIntoDocument(for: userId, with: newImage)
            case .failure(let failure):
                // MARK: todo error handling
                print(failure)
                let errorMessage = (failure as? FirebaseError)?.displayMessage ?? BaseAlertViewModel.genericErrorMessage
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
        userRef.putData(imageData, metadata: nil) { metadata, error in
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

// MARK: UPDATE IMAGE DOCUMENTS
extension ProfileViewModel {
    /// removes an image from the userImages document and removed the image from the 'userImages' Published list for UI update
    private func removeImageFromDocument(userId: String, removedImageId: String) {
        let docRef = firebaseManager.database.collection("userImages").document(userId)
        // local copy so the UI-list won't get updated until the changes were successfully
        var newImages = userImages
        if let index = newImages.firstIndex(where: { $0.id == removedImageId }) {
            newImages.remove(at: index)
            
            let imagesData = newImages.map { $0.toDict(pos: $0.position )}
            docRef.updateData(["images": imagesData]) { error in
                if let error {
                    print("Failed to update user images document", error.localizedDescription)
                    return
                }
                
                print("Successfully updated user images document")
                // new list with removed image is inserted to firestore so we can remove the image from 'userImages'
                if let index = self.userImages.firstIndex(where: { $0.id == removedImageId }) {
                    self.userImages.remove(at: index)
                }
            }
        }
    }
    /// update the order of images in firestore
    func updateImageOrderInFirestore() {
        guard let userId = firebaseManager.userId else { return }
        let images = userImages
        let data = images.enumerated().map { $1.toDict(pos: $0)} // $0 == index, $1 == image
        let docRef = firebaseManager.database.collection("userImages").document(userId)
        docRef.updateData(["images": data]) { error in
            if let error {
                print("error updating other images in user doc", error.localizedDescription)
                return
            }
            print("other images successfully updated\n")
        }
    }
    /// add a uploaded image with url and position into user images document
    private func insertImageIntoDocument(for userId: String, with newImage: SortedImage) {
        let imageData = newImage.toDict(pos: newImage.position)
        firebaseManager.database.collection("userImages").document(userId)
            .setData(["images": FieldValue.arrayUnion([imageData])], merge: true, completion: { error in
                if let error {
                    print("Failed to add new picture to user images document", error.localizedDescription)
                    self.createAlert(title: "Error", message: "We could not save your image... please try again or report a bug")
                    return
                }
                
                print("user images document successfully updated")
                self.fetchUserImages() // fetch images to update UI
            })
    }
}

// MARK: DELETE IMAGES
extension ProfileViewModel {
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
                    self.createAlert(title: "Error", message: "Unfortunately we could not delete your image, please try again or contact us.")
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
extension ProfileViewModel {
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
                self.createAlert(title: "Error", message: error.localizedDescription)
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
