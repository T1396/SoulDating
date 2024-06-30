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
    
    @State private var str: String?

    var body: some View {
        
        TabView {
            ForEach(Tab.allCases) { tab in
                NavigationStack {
                    ZStack {
                        tab.view(user: userViewModel.user)
                            .environmentObject(userViewModel)
                            .environmentObject(chatViewModel)
                            .transition(.slide)
                        
                        NotificationView2(text: $chatViewModel.overlayMessage)
                    }
                    .animation(.easeInOut, value: chatViewModel.showOverlay)
                }
                .tabItem {
                    Label(tab.title, systemImage: tab.icon)
                }
                .tag(tab)
            }
        }
    }
    
}

#Preview {
    NavigationView()
}
