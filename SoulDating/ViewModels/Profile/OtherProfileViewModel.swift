//
//  OtherProfileViewModel.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 30.06.24.
//

import Foundation

/// viewmodel for ProfileView to display another user and his attributes
class OtherProfileViewModel: ObservableObject {
    
    // MARK: properties
    private let firebaseManager = FirebaseManager.shared
    private let rangeManager = RangeManager()
    let otherUser: User
    let currentUser: User
    
    @Published var userImages: [SortedImage] = []
    @Published var userHasMoreImages = true
    
    // MARK: init
    init(currentUser: User, otherUser: User) {
        self.currentUser = currentUser
        self.otherUser = otherUser
        fetchUserImages()
    }
    
    // MARK: computed properties
    var userDescription: String {
        otherUser.general.description ?? "\(otherUser.name ?? "") has no description yet."
    }
    
    var interests: [Interest] {
        otherUser.general.interests ?? []
    }
    
    var goodToKnowRows: [(text: String, icon: String)] {
        [
            (rangeManager.distanceString(from: currentUser.location, to: otherUser.location) ?? "No location set", "arcade.stick"),
            (otherUser.heightString, "pencil.and.ruler.fill"),
            (otherUser.general.job ?? "Not specified", "suitcase.fill"),
            (otherUser.general.education?.title ?? "Not specified", EducationLevel.associate.generalIcon)
        ]
    }
    
    
    var preferenceDetails: [(title: String, pref: Bool?, icon: String)] {
        [ ("Drinkers", otherUser.preferences.drinking, "waterbottle.fill"),
          ("Smokers", otherUser.preferences.smoking, "lungs.fill"),
          ("Childs", otherUser.preferences.wantsChilds, "figure.2.and.child.holdinghands")
        ]
    }
    
    var moreAboutUser: [(title: String, value: String, icon: String)] {
        [
            ("Sexuality", otherUser.general.sexuality?.title ?? "Not specified", "wand.and.stars"),
            ("Job", otherUser.general.job ?? "Not specified", "suitcase.fill"),
            ("Body Type", otherUser.look.bodyType?.title ?? "Not specified", "figure"),
            ("Fashion Style", otherUser.look.fashionStyle?.title ?? "Not specified", "tshirt.fill"),
            ("Fitness Level", otherUser.look.fitnessLevel?.title ?? "Not specified", "dumbbell.fill"),
            ("Drinking Behaviour", otherUser.general.drinkingBehaviour?.title ?? "Not specified", "waterbottle.fill"),
            ("Smoking Status", otherUser.general.smokingStatus?.title ?? "Not specified", "flame.fill")
        ]
    }
    
    // MARK: functions
    private func fetchUserImages() {
        firebaseManager.database.collection("userImages")
            .document(otherUser.id)
            .getDocument { docSnapshot, error in
                if let error {
                    print("error while fetching other user images", error.localizedDescription)
                    return
                }
                
                guard let document = docSnapshot else {
                    self.userHasMoreImages = false
                    return
                }
                
                if let data = document.data(), let imagesData = data["images"] as? [[String: Any]] {
                    let images = imagesData.compactMap { SortedImage(dictionary: $0) }
                    self.userImages = images.sorted(by: { $0.position < $1.position })
                    self.userHasMoreImages = true
                }
            }
    }
    
}
