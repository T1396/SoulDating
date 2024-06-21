//
//  SwipeImageOverlay.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 14.06.24.
//

import SwiftUI

struct SwipeImageOverlay: View {
    @ObservedObject var swipeViewModel: SwipeViewModel
    let targetUser: User
    @Binding var showOptionsSheet: Bool
    @Binding var isMessageScreenActive: Bool
    
    var body: some View {
        VStack {
            userNameOptionsRow
            
            HStack {
                Image(systemName: "location.fill")
                    .font(.caption)
                    .foregroundStyle(.white)
                if let distance = swipeViewModel.distance(to: targetUser) {
                    Text("\(distance) away")
                        .font(.callout)
                        .foregroundStyle(.white.opacity(0.8))
                }
            }
            .itemBackgroundStyleAlt(.black.opacity(0.6), padding: 8, cornerRadius: 20)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            if let date = targetUser.registrationDate, date.isOlderThan30Days {
                HStack {
                    Image(systemName: "fan.fill")
                        .font(.callout)
                        .foregroundStyle(.green.opacity(0.9))
                    Text("New")
                        .font(.callout)
                }
                .itemBackgroundStyleAlt(.white, padding: 8, cornerRadius: 20)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Spacer()
            
            HStack(spacing: 30) {
                controlIcon("xmark.circle.fill", color: .red) {
                    swipeViewModel.setActionAfterSwipe(.dislike, for: targetUser.id)
                }
                controlIcon("message.fill", color: .green) {
                    isMessageScreenActive.toggle()
                }
                controlIcon("heart.fill", color: .red) {
                    swipeViewModel.setActionAfterSwipe(.like, for: targetUser.id)
                }
            }
            .padding(.bottom)
        }
    }
    
    var userNameOptionsRow: some View {
        HStack {
            Text(targetUser.name ?? "")
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
    SwipeImageOverlay(swipeViewModel: SwipeViewModel(user: User(id: "john borno", registrationDate: .now)), targetUser: User(id: "dsa",name: "Borno" ,registrationDate: .now), showOptionsSheet: .constant(true), isMessageScreenActive: .constant(false))
}
