//
//  OtherProfileViewModel.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 30.06.24.
//

import Foundation
import SwiftUI

/// viewmodel for ProfileView to display another user and his attributes
class OtherProfileViewModel: BaseAlertViewModel {

    // MARK: properties
    private let firebaseManager = FirebaseManager.shared
    private let rangeManager = RangeManager.shared
    private let userService: UserService
    let otherUser: FireUser

    @Published var userImages: [SortedImage] = []

    // MARK: init
    init(otherUser: FireUser, userService: UserService = .shared) {
        self.otherUser = otherUser
        self.userService = userService
        super.init()
        fetchUserImages()
    }
    
    // MARK: computed properties
    
    var userDescription: String {
        otherUser.general.description ?? String(format: Strings.noDescriptionText, otherUser.name ?? "")
    }
    
    var interests: [Interest] {
        otherUser.general.interests ?? []
    }
    
    var goodToKnowRows: [(text: String, icon: String)] {
        [
            (rangeManager.distanceString(from: userService.user.location, to: otherUser.location) ?? Strings.noLocationSet, "arcade.stick"),
            (otherUser.heightString, "pencil.and.ruler.fill"),
            (otherUser.general.job ?? Strings.notSpecified, "suitcase.fill"),
            (otherUser.general.education.title, EducationLevel.generalIcon)
        ]
    }
    
    
    var preferenceDetails: [(title: String, pref: Bool?, icon: String)] {
        [ (Strings.drinker, otherUser.preferences.drinking, "waterbottle.fill"),
          (Strings.smoker, otherUser.preferences.smoking, "lungs.fill"),
          (Strings.childs, otherUser.preferences.wantsChilds, "figure.2.and.child.holdinghands")
        ]
    }
    
    var moreAboutUser: [(title: String, value: String, icon: String)] {
        [
            (Strings.sexuality, otherUser.general.sexuality?.title ?? Strings.notSpecified, "wand.and.stars"),
            (Strings.job, otherUser.general.job ?? Strings.notSpecified, "suitcase.fill"),
            (Strings.bodyType, otherUser.look.bodyType.title, "figure"),
            (Strings.fashionStyle, otherUser.look.fashionStyle.title, "tshirt.fill"),
            (Strings.fitnessLevel, otherUser.look.fitnessLevel?.title ?? Strings.notSpecified, "dumbbell.fill"),
            (Strings.drinkingBehaviour, otherUser.general.drinkingBehaviour?.title ?? Strings.notSpecified, "waterbottle.fill"),
            (Strings.smokingBehaviour, otherUser.general.smokingStatus.title, "flame.fill")
        ]
    }
    
    // MARK: functions
    private func fetchUserImages() {
        firebaseManager.database.collection("userImages")
            .document(otherUser.id)
            .getDocument { docSnapshot, error in
                if let error {
                    print("error while fetching other user images", error.localizedDescription)
                    self.createAlert(title: Strings.error, message: Strings.fetchOtherUserError)
                    return
                }
                
                guard let document = docSnapshot else { return }

                if let data = document.data(), let imagesData = data["images"] as? [[String: Any]] {
                    let images = imagesData.compactMap { SortedImage(dictionary: $0) }
                    self.userImages = images.sorted(by: { $0.position < $1.position })
                }
            }
    }
    
}
