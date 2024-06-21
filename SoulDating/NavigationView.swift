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
                        tab.view(user: userViewModel.user)
                            .environmentObject(userViewModel)
                            .environmentObject(chatViewModel)
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
