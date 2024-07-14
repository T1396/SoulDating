//
//  PrivacyView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 05.07.24.
//

import SwiftUI
import Foundation

struct PrivacyView: View {
    @StateObject private var privacyVm = PrivacyViewModel()
    var body: some View {
        Form {
            Section(content: {
                Toggle(Strings.hideUserProfile, isOn: $privacyVm.hideUserProfile)
            }, header: {
                Text(Strings.hideYourself)
            }, footer: {
                Text(Strings.hideSupportText)
            })
        }
    }
}

class PrivacyViewModel: ObservableObject {
    private let firebaseManager = FirebaseManager.shared
    @Published var hideUserProfile: Bool {
        didSet {
            updateHiddenStatus()
        }
    }

    init(userService: UserService = .shared) {
        hideUserProfile = userService.user.isHidden
    }


    func updateHiddenStatus() {
        guard let userId = firebaseManager.userId else { return }
        firebaseManager.database.collection("users")
            .document(userId)
            .updateData(["isHidden": hideUserProfile]) { error in
                if let error {
                    print("Failed to update isHidden field in firestore", error.localizedDescription)
                    return
                }

                print("successfully updated is hidden status")
            }
    }
}

#Preview {
    PrivacyView()
}
