//
//  ProfileSheet.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 21.06.24.
//

import SwiftUI

struct ProfileSheet: View {
    // MARK: properties
    @ObservedObject var otherVm: OtherProfileViewModel
    @ObservedObject var swipeUserVm: SwipeUserViewModel
    @State private var scrollViewContentSize: CGSize = .zero
    @Binding var contentType: MessageAndProfileView.ContentType // to change between messages and profile

    // MARK: body
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 6) {
                    
                    nameGenderRow
                    locationItem
                    
                    Text("About me")
                        .appFont(size: 16, textWeight: .semibold)
                        .padding(.horizontal)
                    Text(otherVm.userDescription)
                        .appFont(size: 12, textWeight: .light)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .itemBackgroundTertiary()
                        .padding(.horizontal)
                    
                    if !otherVm.interests.isEmpty {
                        UserInterestsView(otherVm: otherVm)
                    }
                    
                    GoodToKnowView(otherVm: otherVm)
                    
                    LookingForView(otherVm: otherVm)
                    
                    MoreAboutUserView(otherVm: otherVm)
                    
                }
                .padding(.top, 8)
                .padding(.vertical)
                .padding(.bottom, 80)
                .presentationDragIndicator(.visible)
                .presentationDetents([.fraction(0.4), .large])
            }

            .frame(maxHeight: .infinity, alignment: .topLeading)
            
            
            OverlayControlIcons {
                swipeUserVm.setActionAfterSwipe(.dislike)
            } onMessage: {
                withAnimation {
                    contentType = .message
                }
            } onLike: {
                swipeUserVm.setActionAfterSwipe(.like)
            }
            .frame(maxHeight: .infinity, alignment: .bottom)

        }
    }
    
    // MARK: views
    private var nameGenderRow: some View {
        HStack {
            if let userName = otherVm.otherUser.name, let gender = otherVm.otherUser.gender {
                Text("\(userName), \(otherVm.otherUser.age ?? 18)")
                    .appFont(textWeight: .bold)
                Spacer()
                Text(gender.title)
                    .appFont(size: 14, textWeight: .semibold)
            }
        }
        .padding(.horizontal)
    }
    
    private var locationItem: some View {
        HStack(spacing: 4) {
            Image(systemName: "location.circle.fill")
                .appFont(size: 14)
            Text(otherVm.otherUser.location.name)
                .appFont(size: 14)
        }
        .itemBackgroundTertiary()
        .padding(.horizontal)
    }
}



#Preview {
    ProfileSheet(
        otherVm: OtherProfileViewModel(
            otherUser: FireUser(
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
                preferences: Preferences(height: 180, wantsChilds: true, smoking: false, sports: true, drinking: true, relationshipType: .dating, gender: [.divers, .male, .female], agePreferences: .init(minAge: 25, maxAge: 90)),
                blockedUsers: [],
                registrationDate: .now
                )
        ), swipeUserVm: SwipeUserViewModel(otherUser: FireUser(
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
            preferences: Preferences(height: 180, wantsChilds: true, smoking: false, sports: true, drinking: true, relationshipType: .dating, gender: [.divers, .male, .female], agePreferences: .init(minAge: 25, maxAge: 90)),
            blockedUsers: [],
            registrationDate: .now
        )), contentType: .constant(.message)
    )
    
}
