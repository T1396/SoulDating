//
//  SwipeCardView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 11.06.24.
//

import SwiftUI

/// view for a single swipeable card view
struct SwipeCardView: View {
    // MARK: properties
    @EnvironmentObject var chatViewModel: ChatViewModel
    @ObservedObject var swipeViewModel: SwipeViewModel
    
    let targetUser: User

    @Binding var activeCardID: String?
    @State private var dragAmount: CGSize = .zero // state for the actual position of the card
    @State private var showOptionsSheet = false
    @State private var isMessageScreenActive = false
    
    // MARK: body
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                
                SwipeImage(url: targetUser.profileImageUrl, width: geometry.size.width, height: geometry.size.height)
                
                LinearGradient(colors: [.clear, .black], startPoint: .center, endPoint: .bottom)
                
                SwipeImageOverlay(swipeViewModel: swipeViewModel, targetUser: targetUser, showOptionsSheet: $showOptionsSheet, isMessageScreenActive: $isMessageScreenActive)
                    .padding()
                
                    .sheet(isPresented: $showOptionsSheet) {
                        ReportSheetView(showSheet: $showOptionsSheet, userId: swipeViewModel.userId, reportedUser: targetUser, onBlocked: removeBlockedUser)
                    }
                    .fullScreenCover(isPresented: $isMessageScreenActive) {
                        withAnimation {
                            let chatId = chatViewModel.returnChatIdIfExists(for: targetUser.id)
                            return WriteMessageView(targetUser: targetUser, chatId: chatId,isPresented: $isMessageScreenActive)
                        }
                    }
            }
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .clipped()
            .swipeGesture(dragAmount: $dragAmount, user: targetUser, onSwipe: onSwipe)
            
        }
        .zIndex(targetUser.id == activeCardID ? 1 : 0)
    }
    
    // MARK: functions
    private func onSwipe(action: SwipeAction, user: User) {
        swipeViewModel.setActionAfterSwipe(action, for: user.id)
        swipeViewModel.removeUser(user)
    }
    
    private func removeBlockedUser() {
        withAnimation {
            swipeViewModel.removeUser(targetUser)
        }
    }
}

#Preview {
    SwipeCardView(swipeViewModel: SwipeViewModel(user: User(id: "John", name: "Klaus" ,registrationDate: .now)), targetUser: User(id: "dsa", name: "Klaus" ,registrationDate: .now), activeCardID: .constant("DKASLk"))
}
