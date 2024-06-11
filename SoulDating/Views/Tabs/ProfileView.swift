//
//  ProfileView.swift
//  
//
//  Created by Philipp Tiropoulos on 10.06.24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var activeTab: ProfileTab = .aboutyou

    var body: some View {
        VStack {
            RoundedAsyncImage(imageUrl: userViewModel.user?.profileImageUrl)

            Text(userViewModel.user?.userName ?? "")
                .font(.largeTitle.bold())

            Picker(activeTab.title, selection: $activeTab) {
                ForEach(ProfileTab.allCases) { tab in
                    Text(tab.title).tag(tab)
                }
            }
            .padding(.horizontal, 20)
            .pickerStyle(.segmented)

            if let user = userViewModel.user {
                List(ProfileSection.allSections(profile: user)) { section in
                    Section(section.title) {
                        ForEach(section.items) { item in
                            SettingsElement(item: item)
                        }
                    }
                }
            }
            Spacer()
        }
        .background(Color(.systemGroupedBackground))
    }
}

#Preview {
    ProfileView()
        .environmentObject(UserViewModel())
}
