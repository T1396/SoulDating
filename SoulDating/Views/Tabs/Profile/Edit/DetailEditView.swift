//
//  DetailEditView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 10.06.24.
//

import SwiftUI

struct DetailEditView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    let profileItem: ProfileItem
    var body: some View {
        NavigationStack {
            VStack {
                switch profileItem {
                case .name(let name):
                    EditTextView(text: name) { updatedName in
                        userViewModel.updateProfileItem(.name(updatedName))
                    }
                case .birthdate(let date):
                    EditDateView(date: date)
                case .location(let location):
                    EditTextView(text: location.name) { updatedLocation in
                        // MARK: TODO update location
                    }
                case .lookingFor(let gender):
                    EditTextView(text: gender.title) { updatedGenderPref in
                        // MARK: TODO update gender preferences
                    }
                case .interests(let array):
                    EditListView(items: array)
                }
            }
            .navigationTitle(profileItem.editText)
        }
    }
}

#Preview {
    DetailEditView(profileItem: .name("Klaus"))
}
