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
    @ObservedObject var viewModel: SwipeUserViewModel
    
    @Binding var activeCardID: String?
    @State private var dragAmount: CGSize = .zero // state for the actual position of the card
    @State private var showOptionsSheet = false
    @State private var isMessageScreenActive = false
    
    // MARK: body
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            ZStack(alignment: .bottom) {
            
                UserImage(url: viewModel.otherUser.profileImageUrl, minWidth: width, minHeight: height)
                
                LinearGradient(colors: [.clear, .black], startPoint: .center, endPoint: .bottom)
                
                SwipeImageOverlay(
                    viewModel: viewModel,
                    showOptionsSheet: $showOptionsSheet,
                    isMessageScreenActive: $isMessageScreenActive
                )
                .padding()
                
                .sheet(isPresented: $showOptionsSheet) {
                    ReportSheetView(
                        showSheet: $showOptionsSheet,
                        userId: viewModel.currentUserId,
                        reportedUser: viewModel.otherUser,
                        onBlocked: removeBlockedUser
                    )
                }
                .fullScreenCover(isPresented: $isMessageScreenActive) {
                    withAnimation {
                        let chatId = chatViewModel.returnChatIdIfExists(for: viewModel.otherUser.id)
                        return WriteMessageView(targetUser: viewModel.otherUser, chatId: chatId)
                    }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .clipped()
            // modifier to make whole card swipeable
            .swipeGesture(dragAmount: $dragAmount, user: viewModel.otherUser, onSwipe: onSwipe)
            
        }
        // ensures that the image stays in the foreground when swiping it out
        .zIndex(viewModel.otherUser.id == activeCardID ? 1 : 0)
    }
    
    // MARK: functions
    private func onSwipe(action: SwipeAction, user: User) {
        viewModel.setActionAfterSwipe(action)
    }
    
    private func removeBlockedUser() {
        withAnimation {
            viewModel.removeUser()
        }
    }
}

#Preview {
    SwipeCardView(viewModel: SwipeUserViewModel(currentUserId: "123", otherUser: User(id: "2"), currentLocation: LocationPreference(latitude: 52.10, longitude: 9.10, name: "Hallo", radius: 100)), activeCardID: .constant("2"))
}
