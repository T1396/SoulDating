//
//  ProfileView.swift
//
//
//  Created by Philipp Tiropoulos on 10.06.24.
//

import SwiftUI

struct ProfileView: View {
    // MARK: properties
    @StateObject private var profileViewModel: ProfileViewModel
    @State private var activeTab: ProfileTab = .aboutyou
    @State private var loadedImage: Image?
    @State private var isImagePresented = false
    
    
    // MARK: init
    init(user: User) {
        self._profileViewModel = StateObject(wrappedValue: ProfileViewModel(user: user))
    }
    
    // MARK: body
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                
                VStack(alignment: .leading, spacing: 0) {
                    VStack(alignment: .leading, spacing: 2) {
                        // expands the toolbar
                        ProfileImageHeaderView(user: profileViewModel.user, loadedImage: $loadedImage, isImagePresented: $isImagePresented)
                            .padding(.horizontal, 20)
                        profileTabView
                            .padding(.horizontal)
                            .padding(.vertical, 6)
                        Divider()
                        
                    }
                    .frame(maxWidth: .infinity)
                    .background(.accent.quinary)
                    
                    activeTab.view()
                        .environmentObject(profileViewModel)
                }
                .frame(maxWidth: .infinity)
                
                if isImagePresented {
                    OverlayImageView(isImagePresented: $isImagePresented, loadedImage: $loadedImage, width: geometry.size.width * 0.9, height: geometry.size.height * 0.8)
                }
                
                NotificationView2(text: $profileViewModel.overlayMessage)
                
                
            }
            .overlay(
                profileViewModel.showOverlay ? NotificationView(title: "Success", systemName: "xmark", show: $profileViewModel.showOverlay, action: {
                    profileViewModel.showOverlay = false
                })
                .transition(.move(edge: .top))
                : nil,
                alignment: .top
            )
            .animation(.easeInOut, value: profileViewModel.showOverlay)
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Text(Tab.profile.title)
                    .appFont(size: 26 ,textWeight: .bold)
                    .toolbarColorScheme(.dark, for: .automatic)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Image(systemName: "gear.circle")
            }
        }
        .alert(isPresented: $profileViewModel.showAlert) {
            Alert(
                title: Text(profileViewModel.alertTitle),
                message: Text(profileViewModel.alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    // MARK: views
    var profileTabView: some View {
        HStack {
            ForEach(ProfileTab.allCases) { tab in
                Text(tab.title)
                    .appFont(size: 12, textWeight: activeTab == tab ? .semibold : .regular)
                    .padding(8)
                    .padding(.horizontal, 4)
                    .foregroundStyle(activeTab == tab ? .buttonText : .primary)
                    .background(activeTab == tab ? .accent : .clear, in:Capsule(style: .continuous))
                    .onTapGesture {
                        withAnimation {
                            activeTab = tab
                        }
                    }
            }
        }
    }
}


extension View {
    func navigationBarColor(backgroundColor: UIColor, foregroundColor: UIColor) -> some View {
        self.onAppear {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = backgroundColor
            appearance.titleTextAttributes = [.foregroundColor: foregroundColor]
            appearance.largeTitleTextAttributes = [.foregroundColor: foregroundColor]
            
            appearance.shadowColor = nil // hide divider/shadow
            
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().compactAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

#Preview {
    ProfileView(user: User(id: "das", name: "Hannelore"))
        .environmentObject(UserViewModel())
}
