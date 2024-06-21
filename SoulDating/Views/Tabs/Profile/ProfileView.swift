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
    @StateObject private var profileViewModel: ProfileViewModel
    
    init(user: User) {
        self._profileViewModel = StateObject(wrappedValue: ProfileViewModel(user: user))
    }

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack(alignment: .leading) {
                    HStack {
                        RoundAsyncImage(imageUrl: userViewModel.user.profileImageUrl, progress: 40, width: 80, height: 80)
                        
                        VStack {
                            Text(userViewModel.user.name ?? "")
                                .appFont(size: 22, textWeight: .bold)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    HStack {
                        ForEach(ProfileTab.allCases) { tab in
                            Text(tab.title)
                                .appFont(size: 12, textWeight: activeTab == tab ? .semibold : .regular)
                                .padding(8)
                                .padding(.horizontal, 4)
                                .foregroundStyle(.black)
                                .background(activeTab == tab ? .cyan.opacity(0.3) : .clear, in:Capsule(style: .continuous))
                                .onTapGesture {
                                    withAnimation {
                                        activeTab = tab
                                    }
                                }
                        }
                    }
                    .padding()
                    
                    activeTabView()
                        .environmentObject(profileViewModel)
                    
//                    List(ProfileSection.allSections(profile: userViewModel.user)) { section in
//                        Section(section.title) {
//                            ForEach(section.items) { item in
//                                SettingsElement(item: item)
//                            }
//                        }
//                    }
                    Spacer()
                }
                .background(Color(.systemGroupedBackground))
                .navigationBarTitleDisplayMode(.inline)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text(Tab.profile.title)
                        .appFont(size: 26 ,textWeight: .bold)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Image(systemName: "gear.circle")
                }
            }
        }
    }
    @ViewBuilder
    private func activeTabView() -> some View {
        switch activeTab {
        case .aboutyou:
            AboutYouView(user: userViewModel.user)
        case .preferences:
            PreferencesView(user: userViewModel.user)
        case .fotos:
            PhotosView()
        }
    }
}

#Preview {
    ProfileView(user: User(id: "das", name: "Hannelore"))
        .environmentObject(UserViewModel())
}
