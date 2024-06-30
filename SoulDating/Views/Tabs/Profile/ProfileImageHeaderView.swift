//
//  ProfileImageHeaderView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 22.06.24.
//

import SwiftUI

struct ProfileImageHeaderView: View {
    var user: User
    @Binding var loadedImage: Image?
    @Binding var isImagePresented: Bool
    
    var body: some View {
        print("Percent: \(user.totalPercent)")
        return HStack {
            UserProgressImage(imageUrl: user.profileImageUrl, width: 80, height: 80, userProgress: CGFloat(user.totalPercent), onAppear: { image in
                loadedImage = image
            })
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isImagePresented = true
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(user.nameAgeString)
                    .appFont(size: 22, textWeight: .bold)
                    .padding(.leading, 6)
                Text("\(user.totalPercent, specifier: "%.0f")% completed")
                    .appFont(size: 16, textWeight: .semibold)
                    .itemBackgroundStyleAlt(.accent, padding: 6, cornerRadius: 30)
                    .foregroundStyle(.buttonText)
            }
        }
    }
}

#Preview {
    ProfileImageHeaderView(user: User(
        id: "12345",
        name: "Jane Doe",
        profileImageUrl: "https://example.com/image.jpg",
        birthDate: Date(),
        gender: .female,
        onboardingCompleted: true,
        general: UserGeneral(
            education: .master,
            smokingStatus: .chainSmoker,
            sexuality: .hetero,
            job: "Software Engineer",
            languages: ["English", "Spanish"],
            drinkingBehaviour: .nonDrinker,
            interests: [.animals, .art],
            description: "Enthusiastic outdoors lover and bookworm."
        ),
        location: LocationPreference(
            latitude: 34.0522,
            longitude: -118.2437,
            name: "Los Angeles",
            radius: 50.0
        ),
        look: Look(
            height: 170,
            bodyType: .athletic,
            fashionStyle: .casual,
            fitnessLevel: .lightly
        ),
        preferences: Preferences(
            height: 175,
            wantsChilds: false,
            distance: 100,
            smoking: true,
            sports: false,
            drinking: true,
            relationshipType: .longTerm,
            gender: [.male],
            agePreferences: AgePreference(minAge: 25.0, maxAge: 35.0)
        ),
        blockedUsers: ["98765"],
        registrationDate: Date()
    ), loadedImage: .constant(nil), isImagePresented: .constant(true))
}


#Preview {
    ProfileImageHeaderView(user: User(
        id: "12345",
        name: "kldas",
        profileImageUrl: "https://firebasestorage.googleapis.com:443/v0/b/souldating-b6486.appspot.com/o/profileImages%2F66K5In3reXQc8mMuqdkISd3l4I63%2F64C16806-76D0-407C-96E4-7F6DDE7CF7F8.jpg?alt=media&token=3dab4679-4cc7-471a-9de4-75e29b3395ad"
    ), loadedImage: .constant(nil), isImagePresented: .constant(true))
}

