//
//  ProfileView.swift
//
//
//  Created by Philipp Tiropoulos on 10.06.24.
//

import SwiftUI

struct ProfileView: View {
    // MARK: properties
    @EnvironmentObject var userVm: UserViewModel

    @StateObject private var editVm = EditUserViewModel()
    @StateObject private var imagesVm = ImagesViewModel()

    @State private var activeTab: ProfileTab = .aboutyou
    @State private var loadedImage: Image?
    @State private var isImagePresented = false
    @State private var openSettings = false

    @Binding var user: FireUser

    // MARK: init
    init() {
        _user = Binding(get: { UserService.shared.user }, set: { UserService.shared.user = $0 })
    }

    // MARK: body
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                
                VStack(alignment: .leading, spacing: 0) {
                    VStack(alignment: .leading, spacing: 2) {
                        HStack {
                            Text(Tab.profile.title)
                                .appFont(size: 26, textWeight: .bold)

                            Spacer()

                            Button {
                                openSettings = true
                            } label: {
                                Image(systemName: "gear")
                            }
                            .foregroundStyle(.foreground)
                            .navigationDestination(isPresented: $openSettings) {
                                SettingsView()
                                    
                            }
                        }
                        .padding(.horizontal)
                        ProfileImageHeaderView(user: $user, loadedImage: $loadedImage, isImagePresented: $isImagePresented)
                            .padding(.horizontal, 20)

                        
                    }
                    .padding(.bottom, 8)
                    .frame(maxWidth: .infinity)
                    .background(.secondaryAccent)

                    CustomTabView(activeTab: $activeTab)

                    activeTab.view(profileVm: imagesVm)
                        .environmentObject(editVm)
                }
                .frame(maxWidth: .infinity)
                
                if isImagePresented {
                    OverlayImageView(
                        imagesVm: imagesVm,
                        isImagePresented: $isImagePresented,
                        loadedImage: $loadedImage,
                        activeTab: $activeTab,
                        width: geometry.size.width * 0.9,
                        height: geometry.size.height * 0.8
                    )
                }
                
                NotificationView2(text: $imagesVm.overlayMessage)
                    .animation(.easeInOut, value: imagesVm.showOverlay)
                
            }
        }


        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .navigationBar)
        .alert(isPresented: $imagesVm.showAlert) {
            Alert(
                title: Text(imagesVm.alertTitle),
                message: Text(imagesVm.alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(UserViewModel())
}
