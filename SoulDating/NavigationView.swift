//
//  ContentView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 04.06.24.
//

import SwiftUI
import Firebase

struct NavigationView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @StateObject private var chatViewModel = ChatViewModel()

    var body: some View {
        
        TabView {
            ForEach(Tab.allCases) { tab in
                NavigationStack {
                    ZStack {
                        tab.view(user: UserService.shared.user)
                            .environmentObject(userViewModel)
                            .environmentObject(chatViewModel)
                        
                        NotificationView2(text: $chatViewModel.overlayMessage)

                        ChatNotificationView(chatNotification: $chatViewModel.chatNotification)
                    }
                    .animation(.easeInOut, value: chatViewModel.showOverlay)
                }
                .tabItem {
                    Label(tab.title, systemImage: tab.icon)
                }
                .badge(tab == .messages ? chatViewModel.unreadMessagesCount : 0)
                .tag(tab)
            }
        }
    }
}

#Preview {
    NavigationView()
}
