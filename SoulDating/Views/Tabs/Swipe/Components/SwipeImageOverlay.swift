//
//  SwipeImageOverlay.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 14.06.24.
//

import SwiftUI

struct SwipeImageOverlay: View {
    // MARK: properties
    @ObservedObject var viewModel: SwipeUserViewModel
    @Binding var showOptionsSheet: Bool
    @Binding var navigateToProfileOrMessage: Bool
    @State private var isListVisible = false
    
    // MARK: computed properties
    var user: FireUser {
        viewModel.otherUser
    }
    
    // MARK: body
    var body: some View {
        VStack {
            userNameOptionsRow
            
            HStack {
                Image(systemName: "location.fill")
                    .appFont(size: 12)
                    .frame(width: 16)
                    .foregroundStyle(.white)
                if let distance = viewModel.distance {
                    Text("\(distance) away")
                        .appFont(size: 14)
                        .foregroundStyle(.white.opacity(0.8))
                }
            }
            .itemBackgroundStyleAlt(.black.opacity(0.6), padding: 8, cornerRadius: 20)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            if viewModel.isNewUser {
                HStack {
                    Image(systemName: "fan.fill")
                        .appFont(size: 12)
                        .frame(width: 16)
                        .foregroundStyle(.green.opacity(0.9))
                    Text("New")
                        .appFont(size: 12)
                }
                .itemBackgroundStyleAlt(.white, padding: 8, cornerRadius: 20)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Button {
                withAnimation {
                    isListVisible.toggle()
                }
                


            } label: {
                VStack {
                    HStack {
                        Image(systemName: "list.bullet")
                            .appFont(size: 12)
                            .rotationEffect(isListVisible ? .degrees(180) : .zero)
                            .frame(width: 16)
                            .foregroundStyle(.white)
                        Text("More")
                            .foregroundStyle(.white)
                            .appFont(size: 12)
                    }
                    .frame(maxWidth: isListVisible ? .infinity : nil, alignment: .leading)

                    
                    if isListVisible {
                        VStack {
                            Text("Location: \(user.location.name)")
                                .appFont(size: 12)
                                .padding(5)
                                .background(.gray.opacity(0.2), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                            
                            if let gender = user.gender {
                                Text("Gender: \(gender.title)")
                                    .appFont(size: 12)
                                    .padding(8)
                                    .background(.gray.opacity(0.2), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                            }
                            
                            if let job = user.general.job {
                                Text("Job: \(job)")
                                    .appFont(size: 12)
                                    .padding(8)
                                    .background(.gray.opacity(0.2), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                            }
                            
                            if let height = user.look.height {
                                Text("Height: \(height)")
                                    .appFont(size: 12)
                                    .padding(8)
                                    .background(.gray.opacity(0.2), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                            }
                            
                            ForEach(user.general.interests ?? []) { interest in
                                Text(interest.title)
                                    .padding(8)
                                    .appFont(size: 12)
                                    .background(.gray.opacity(0.2), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                            }
                        }
                        .foregroundStyle(.white)
                        .transition(.opacity.animation(.easeInOut(duration: 0.15)))
                    }
                }
                .frame(maxWidth: isListVisible ? 100 : nil, alignment: .leading)
                .padding(8)
                .background(isListVisible ? .black.opacity(0.4) : .blue.opacity(0.6), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
                        
            Spacer()
            
            OverlayControlIcons {
                // dislike
                viewModel.setActionAfterSwipe(.dislike)
            } onMessage: {
                navigateToProfileOrMessage.toggle()
            } onLike: {
                viewModel.setActionAfterSwipe(.like)
            }
        }
    }
    
    var userNameOptionsRow: some View {
        HStack {
            Text(user.nameAgeString)
                .padding(.horizontal, 10)
                .foregroundStyle(.white)
                .font(.title2)
                .fontWeight(.heavy)
            
            Spacer()
            
            Button(action: {
                showOptionsSheet.toggle()
            }, label: {
                Image(systemName: "ellipsis")
                    .font(.title)
                    .foregroundStyle(.white)
            })
        }
    }
}



#Preview {
    SwipeImageOverlay(
        viewModel: SwipeUserViewModel(
            otherUser: FireUser(
                id: "2",
                general: UserGeneral(job: "Klempner", interests: [.animals, .art, .astrology]),
                look: Look(height: 180)
            )
        ),
        showOptionsSheet: .constant(false),
        navigateToProfileOrMessage: .constant(false)
    )
}
