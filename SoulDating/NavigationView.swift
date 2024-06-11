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
    
    var body: some View {
        NavigationStack {
            TabView {
                ForEach(Tab.allCases) { tab in
                    NavigationStack {
                        tab.view
                            .environmentObject(userViewModel)
                            .navigationTitle(tab.title)
                    }
                    .tabItem {
                        Label(tab.title, systemImage: tab.icon)
                    }
                    .tag(tab)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: userViewModel.logout) {
                        Image(systemName: "power")
                    }
                }
            }
        }
    }
    
}

#Preview {
    NavigationView()
}
