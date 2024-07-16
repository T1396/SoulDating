//
//  OtherUserVie.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 28.06.24.
//

import SwiftUI
import SDWebImageSwiftUI

struct OtherUserProfileView: View {
    // MARK: properties
    @EnvironmentObject var userViewModel: UserViewModel

    @StateObject private var otherVm: OtherProfileViewModel
    @StateObject private var swipeUserVm: SwipeUserViewModel

    @Binding var image: Image?
    @Binding var contentType: MessageAndProfileView.ContentType // to change between messages and profile

    @State private var showImagesView = false
    @State private var showSheet = true

    @Environment(\.dismiss) var dismiss

    // MARK: init
    init(image: Binding<Image?>, targetUser: FireUser, contentType: Binding<MessageAndProfileView.ContentType>, isLikedOrDislikedAlready: Bool = false) {
        self._otherVm = StateObject(wrappedValue: OtherProfileViewModel(otherUser: targetUser))
        self._swipeUserVm = StateObject(wrappedValue: SwipeUserViewModel(otherUser: targetUser))
        self._image = image
        self._contentType = contentType
    }
    
    // MARK: body
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width - 32
            let height = width / 3 * 4.6
            ZStack {
                
                VStack {
                    if let image {
                        image
                            .resizable()
                            .scaledToFit()
                            .onTapGesture(perform: showImageOverlay)
                    } else {
                        loadAsynImage()
                            .onTapGesture(perform: showImageOverlay)
                    }
                    Spacer()
                }

                BackArrow {
                    withAnimation {
                        dismiss()
                    }
                }
                .foregroundStyle(.black)
                .padding(.top, 49)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

                if showImagesView {
                    VStack {
                        Text(Strings.otherPhotos)
                            .appFont(size: 16, textWeight: .semibold)
                            .padding(.horizontal)
                        
                        TabView {
                            ForEach(otherVm.userImages) { image in
                                RoundedWebImage(imageUrl: image.imageUrl, width: width, height: height)
                                    .onTapGesture(perform: hideImageOverlay)
                            }
                        }
                        .tabViewStyle(PageTabViewStyle())
                    }
                    .background(.black.opacity(0.5))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .sheet(isPresented: $showSheet) {
            ProfileSheet(otherVm: otherVm, swipeUserVm: swipeUserVm, contentType: $contentType, otherUser: otherVm.otherUser)
                .transition(.move(edge: .bottom))
                .interactiveDismissDisabled()
                .presentationDragIndicator(.visible)
                .presentationBackgroundInteraction(.enabled)
                .presentationDetents([.fraction(0.4), .fraction(0.8)])
        }
        .toolbar(.hidden)
        .navigationBarBackButtonHidden(false)
        .ignoresSafeArea(edges: .top)
    }
    
    // MARK: views
    @ViewBuilder
    private func loadAsynImage() -> some View {
        if let url = URL(string: otherVm.otherUser.profileImageUrl ?? "") {
            WebImage(url: url) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                Image(systemName: "photo.fill")
                    .resizable()
                    .scaledToFit()
                    .padding(40)
                    .frame(maxWidth: .infinity)
            }
        } else {
            Image(systemName: "photo.fill")
                .resizable()
                .scaledToFit()
                .padding(40)
                .frame(maxWidth: .infinity)
            
        }
    }
    
    // MARK: functions
    private func showImageOverlay() {
        if !otherVm.userImages.isEmpty {
            withAnimation {
                showSheet = false
                showImagesView = true
            }
        }
    }
    
    private func hideImageOverlay() {
        withAnimation {
            showSheet = true
            showImagesView = false
        }
    }
}

#Preview {
    OtherUserProfileView(
        image: .constant(nil),
        targetUser: FireUser(
            id: "1",
            name: "Hannelor",
            profileImageUrl: "https://firebasestorage.googleapis.com:443/v0/b/souldating-b6486.appspot.com/o/profileImages%2FFW4oOlh92QUyzxUd8reUoYVSBfn2%2F8E55C58C-C011-4A27-B64F-78FDF5921167.jpg?alt=media&token=ad2b148f-3685-40e3-a28a-fbbe7ad2495e",
            birthDate: .now.subtractYears(18),
            gender: .randomGender(),
            onboardingCompleted: true,
            general: UserGeneral(
                education: .associate,
                smokingStatus: .chainSmoker,
                sexuality: .asexual,
                job: "Mechanic",
                languages: [],
                drinkingBehaviour: .nonDrinker,
                interests: [.animals, .birdwatching, .gardening, .fashion, .fitness],
                description: "Hi! Ich bin Max, 29, aus Berlin. Leidenschaftlicher Fotograf, Hobbykoch und Abenteurer. Suche jemanden zum Lachen und Leben entdecken. Lust auf ein Treffen?"
            ),
            location: Location(latitude: 51.001, longitude: 9.100, name: "Berlin", radius: 100),
            look: Look(height: 180, bodyType: .athletic, fashionStyle: .business, fitnessLevel: .athlete),
            preferences: Preferences(height: 180, wantsChilds: true, smoking: false, sports: true, drinking: true, relationshipType: .dating, gender: [.divers, .male, .female], agePreferences: .init(minAge: 25, maxAge: 90)),
            blockedUsers: [],
            registrationDate: .now
        ), contentType: .constant(.profile)
    )
    .environmentObject(UserViewModel())
}
