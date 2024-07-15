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
    @ObservedObject var swipeUserVm: SwipeUserViewModel
    @Binding var activeCardID: String?

    @State private var image: Image?
    @State private var dragAmount: CGSize = .zero // state for the actual position of the card
    @State private var showOptionsSheet = false
    @State private var navigateToProfileOrMessage = false
    
    // MARK: body
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            ZStack(alignment: .bottom) {
                
                UserImage(url: swipeUserVm.otherUser.profileImageUrl, minWidth: width, minHeight: height) { image in
                    self.image = image
                }
                
                LinearGradient(colors: [.clear, .black.opacity(0.8)], startPoint: .center, endPoint: .bottom)

                SwipeImageOverlay(viewModel: swipeUserVm, showOptionsSheet: $showOptionsSheet, navigateToProfileOrMessage: $navigateToProfileOrMessage)
                .padding()
                
                .sheet(isPresented: $showOptionsSheet) {
                    ReportSheetView(
                        showSheet: $showOptionsSheet,
                        reportedUser: swipeUserVm.otherUser,
                        onBlocked: removeBlockedUser
                    )
                }
            }
            .fullScreenCover(isPresented: $navigateToProfileOrMessage) {
                let chatId = ChatService.shared.returnChatIdIfExists(for: swipeUserVm.otherUser.id)
                MessageAndProfileView(targetUser: swipeUserVm.otherUser, chatId: chatId, image: $image)
            }

            .frame(width: geometry.size.width, height: geometry.size.height)
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .clipped()
            // modifier to make whole card swipeable
            .swipeGesture(dragAmount: $dragAmount, user: swipeUserVm.otherUser, onSwipe: onSwipe)
            
        }
        // ensures that the image stays in the foreground when swiping it out
        .zIndex(swipeUserVm.otherUser.id == activeCardID ? 1 : 0)
    }
    
    // MARK: functions
    private func onSwipe(action: SwipeAction, user: FireUser) {
        withAnimation {
            swipeUserVm.setActionAfterSwipe(action)
        }
    }
    
    private func removeBlockedUser() {
        withAnimation {
            swipeUserVm.removeUserAfterBlock()
        }
    }
}

#Preview {
    SwipeCardView(swipeUserVm: SwipeUserViewModel(otherUser: FireUser(id: "2")), activeCardID: .constant("2"))
        .environmentObject(MessagesViewModel())
}
