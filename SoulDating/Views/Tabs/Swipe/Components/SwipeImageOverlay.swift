//
//  SwipeImageOverlay.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 14.06.24.
//

import SwiftUI

struct SwipeImageOverlay: View {
    @ObservedObject var viewModel: SwipeUserViewModel
    @Binding var showOptionsSheet: Bool
    @Binding var isMessageScreenActive: Bool
    
    @State private var isListVisible = false
    var user: User {
        viewModel.otherUser
    }
    
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
                }
                isListVisible.toggle()


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
                        VStack() {
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
//                        .transition(.asymmetric(insertion: .move(edge: .top).combined(with: .offset(y: -40)), removal: .push(from: .bottom)).combined(with: .offset(y: -0)))
                    }
                }
                .frame(maxWidth: isListVisible ? 100 : nil, alignment: .leading)
                .padding(8)
                .background(isListVisible ? .black.opacity(0.4) : .blue.opacity(0.6), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            
            
                        
            Spacer()
            
            HStack(spacing: 30) {
                controlIcon("xmark.circle.fill", color: .red) {
                    withAnimation {
                        viewModel.setActionAfterSwipe(.dislike)
                    }
                }
                controlIcon("message.fill", color: .green) {
                    isMessageScreenActive.toggle()
                }
                controlIcon("heart.fill", color: .red) {
                    viewModel.setActionAfterSwipe(.like)
                }
            }
            .padding(.bottom)
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
            
            Button(action: { showOptionsSheet.toggle() }) {
                Image(systemName: "ellipsis")
                    .font(.title)
                    .foregroundStyle(.white)
            }
        }
    }
    
    @ViewBuilder
    private func controlIcon(_ systemName: String, color: Color, action: @escaping() -> Void) -> some View {
        Button {
            print("clicked control icon")
            action()
        } label: {
            Image(systemName: systemName)
                .font(.title)
                .foregroundStyle(color)
                .padding()
                .background()
                .clipShape(Circle())
        }
    }
}

#Preview {
    SwipeImageOverlay(
        viewModel: SwipeUserViewModel(
            currentUserId: "dlsöa",
            otherUser: User(
                id: "2",
                general: UserGeneral(job: "Klempner", interests: [.animals, .art, .astrology]),
                look: Look(height: 180)
            ),
            currentLocation: LocationPreference(
                latitude: 52.102,
                longitude: 10.9123,
                name: "Berlin",
                radius: 100
            )
        ),
        showOptionsSheet: .constant(false),
        isMessageScreenActive: .constant(false)
    )
}
