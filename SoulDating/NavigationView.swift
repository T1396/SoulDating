//
//  ContentView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 04.06.24.
//

import SwiftUI
import Firebase
import Combine

struct NavigationView: View {
    // MARK: properties
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var activeTab: Tab = .swipe
    @State private var unreadMessagesCount = 0
    @State private var cancellable: AnyCancellable?

    // MARK: body
    var body: some View {

        TabView(selection: $activeTab) {
            ForEach(Tab.allCases) { tab in
                NavigationStack {
                    tab.view(activeTab: $activeTab)
                        .environmentObject(userViewModel)
                }

                .tabItem {
                    Label(tab.title, systemImage: tab.icon)
                }
                .badge(tab == .messages ? unreadMessagesCount : 0)
                .tag(tab)
            }
        }
        .overlay {
            ChatNotificationView()
        }
        .onAppear {
            subscripeToUnreadMessages()
        }
        .onDisappear {
            cancellable?.cancel()
        }
    }

    // using combine to update badge number because with a viewModel wrapper like environmentObject whole navigation view was rerendered everytime the badge updated
    private func subscripeToUnreadMessages() {
        cancellable = ChatService.shared.$unreadMessagesCount
            .receive(on: DispatchQueue.main)
            .sink { newCount in
                unreadMessagesCount = newCount
            }
    }

}

struct BadgeView: View {
    @EnvironmentObject var chatService: ChatService
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.red)
                .frame(width: 20, height: 20)
            Text("\(chatService.unreadMessagesCount)")
                .foregroundColor(.white)
                .font(.system(size: 12))
        }
        .opacity(chatService.unreadMessagesCount > 0 ? 1 : 0) // Hide the badge if count is 0

    }
}

#Preview {
    NavigationView()
        .environmentObject(UserViewModel())
}
