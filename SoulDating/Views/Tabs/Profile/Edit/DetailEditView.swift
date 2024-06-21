//
//  DetailEditView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 10.06.24.
//

import SwiftUI

struct DetailEditView: View {
    @StateObject private var editViewModel: AboutYouViewModel
    
    init(user: User, profileItem: ProfileItem) {
        self._editViewModel = StateObject(wrappedValue: AboutYouViewModel(user: user))
        self.profileItem = profileItem
    }
    let profileItem: ProfileItem
    var body: some View {
        NavigationStack {
            VStack {
//                switch profileItem {
//                    /// general section
//                case .name(let name):
//                    EditNameView(title: profileItem.title, text: name, user: editViewModel.user)
//                    
//                case .birthdate(let date):
//                    EditDateView(date: date, user: editViewModel.user, profileItem: profileItem)
//                    
//                case .gender(let gender):
//                    EditGenderView(gender: gender, user: editViewModel.user, profileItem: profileItem)
//                    
//                case .location(let location):
//                    EditLocationRangeView(location: location, user: editViewModel.user)
//                    
//                case .ageRangePreference(let agePref):
//                    if let agePref {
//                        EditAgeRangeView(user: editViewModel.user, agePreference: agePref, profileItem: profileItem)
//                    }
//                    
//                    /// more about you section
//                case .description(_):
//                    // MARK: TODO description edit view
//                    EmptyView()
//                    
//                case .height(_):
//                    EmptyView()
//                    
//                case .job(_):
//                    // MARK: TODO job edit view
//                    EmptyView()
//                    
//                case .languages(_):
//                    // MARK: TODO languages edit view
//                    EmptyView()
//                    
//                case .smokingStatus(_):
//                    EmptyView()
//                    
//                case .interests(let interests):
//                    EditListView(items: interests.map { $0.title }, action: {})
//                    
//                case .education(_):
//                    EmptyView()
//                    
//                    
//                    
//                    /// preferences section
//                case .preferredGender(let gender):
//                    EditGenderView(gender: gender, user: editViewModel.user, profileItem: profileItem)
//                case .heightPreference(_):
//                    EmptyView()
//                case .smokingPreference(_):
//                    EmptyView()
//                }
            }
        }
    }
}

#Preview {
    DetailEditView(user: User(id: "kdlsa", userName: "Klasdadsadkl" ,registrationDate: .now), profileItem: .preferredGender(.divers))
}
