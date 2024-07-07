//
//  ProfileSheet.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 21.06.24.
//

import SwiftUI

struct ProfileSheet: View {
    let user: User
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
                if let userName = user.name, let gender = user.gender {
                    Text("\(userName), \(user.age ?? 18)")
                        .font(.title.bold())
                    Spacer()
                    Text(gender.title)
                }
                
            }
            if let locationName = user.location?.name {
                Text(locationName)
            }
            if let interests = user.general?.interests {
                HStack {
                    ForEach(interests) { interest in
                        HStack {
                            Image(systemName: interest.icon)
                                .font(.caption.bold())
                            Text(interest.title)
                        }
                        .itemBackgroundStyle(padding: CGFloat(8))
                    }
                }
            }
            
            if let description = user.general?.description {
                Text(description)
            }

            
            Text("More")
                .appFont(size: 14)
            
            if let gender = user.gender {
                Text("\(user.name ?? "") identifies as a \(gender.secTitle)")
            }
            
            if let education = user.general?.education, let userName = user.name {
                HStack {
                    Text("\(userName)'s education level")
                    Text(education.title)
                }
            }
            
            Spacer()
        }
        .padding(.top, 8)
        .padding()
        .presentationDragIndicator(.visible)
        .presentationDetents([.fraction(0.4), .large])
    }
}

#Preview {
    ProfileSheet(user: User(id: "kdlsa", name: "Kldsakdlk"))
}
