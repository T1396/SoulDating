//
//  OtherUserVie.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 28.06.24.
//

import SwiftUI


struct OtherUserProfileView: View {
    // MARK: properties
    @EnvironmentObject var userViewModel: UserViewModel
    @StateObject private var otherVm: OtherProfileViewModel
    @Binding var showProfile: Bool
    @State private var showImagesView = false
    @State private var showSheet = true
    @Binding var image: Image?
    let targetUser: User
    
    // MARK: init
    init( showProfile: Binding<Bool>, image: Binding<Image?>, targetUser: User, user: User) {
        self._otherVm = StateObject(wrappedValue: OtherProfileViewModel(currentUser: user, otherUser: targetUser))
        self._showProfile = showProfile
        self._image = image
        self.targetUser = targetUser
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
                
                Button {
                    showProfile.toggle()
                } label: {
                    Image(systemName: "chevron.left")
                        .padding(8)
                        .background(.white.opacity(0.9), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                }
                .padding()
                .padding(.top, 44)
                .offset(x: -6)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                
                if showImagesView {
                    
                    VStack {
                        Text("Other photos")
                            .appFont(size: 16, textWeight: .semibold)
                            .padding(.horizontal)
                        
                        TabView {
                            ForEach(otherVm.userImages) { image in
                                RoundedAsyncImage(imageUrl: image.imageUrl, width: width, height: height)
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
        .ignoresSafeArea(edges: .top)
        .sheet(isPresented: $showSheet) {
            ProfileSheet(otherVm: otherVm)
                .transition(.move(edge: .bottom))
                .interactiveDismissDisabled()
                .presentationDragIndicator(.visible)
                .presentationBackgroundInteraction(.enabled)
                .presentationDetents([.fraction(0.4), .fraction(0.8)])
        }
        
    }
    
    // MARK: views
    @ViewBuilder
    private func loadAsynImage() -> some View {
        if let url = URL(string: targetUser.profileImageUrl ?? "") {
            AsyncImage(url: url) { image in
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
        withAnimation {
            showSheet = false
            showImagesView = true
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
        showProfile: .constant(true), image: .constant(nil),
        targetUser: User(
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
            location: LocationPreference(latitude: 51.001, longitude: 9.100, name: "Berlin", radius: 100),
            look: Look(height: 180, bodyType: .athletic, fashionStyle: .business, fitnessLevel: .athlete),
            preferences: Preferences(height: 180, wantsChilds: true, distance: 100, smoking: false, sports: true, drinking: true, relationshipType: .dating, gender: [.divers, .male, .female], agePreferences: .init(minAge: 25, maxAge: 90)),
            blockedUsers: [],
            registrationDate: .now
        ), user: User(id: "3"))
    .environmentObject(UserViewModel())
}
