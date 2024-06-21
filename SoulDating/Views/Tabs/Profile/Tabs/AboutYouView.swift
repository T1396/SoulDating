//
//  AboutYouView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 20.06.24.
//

import SwiftUI

struct AboutYouView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @StateObject private var aboutYouVm: AboutYouViewModel
    
    init(user: User) {
        self._aboutYouVm = StateObject(wrappedValue: AboutYouViewModel(user: user))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(AboutYouSection.allCases) { section in
                    Text(section.displayName)
                        .appFont(size: 20, textWeight: .bold)
                        .padding(.horizontal)
                    
                    ForEach(section.items(user: userViewModel.user)) { item in
                        SettingsElement(title: item.title, value: item.valueString) {
                            item.editView(user: userViewModel.user)
                                .presentationDetents([.medium, .large])
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 6)
                        .id(item.id)

                    }
                }
            }
        }
        .scrollIndicators(.hidden)
    }
}

#Preview {
    AboutYouView(user: User(id: "dksal", name: "hsdoak", profileImageUrl: "dlksadkl"))
}
