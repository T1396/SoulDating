//
//  LikesView.swift
//
//
//  Created by Philipp Tiropoulos on 10.06.24.
//

import SwiftUI



struct LikesView: View {
    // MARK: properties
    @StateObject private var likesViewModel = LikesViewModel()

    init(activeTabViewTab: Binding<Tab>) {
        self._activeTabViewTab = activeTabViewTab
        print("LikesView initialized")
    }
    @Binding var activeTabViewTab: Tab



    // MARK: body
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                CustomTabView(activeTab: $likesViewModel.likesTab)
                Spacer()
                if likesViewModel.finishedInitialLoading {
                    if likesViewModel.sortedUsers.isEmpty {
                        emptyStateContent

                    } else {
                        LikesUserGrid(currentUsers: likesViewModel.sortedUsers, likesViewModel: likesViewModel, likesTab: likesViewModel.likesTab)
                            .animation(.easeInOut, value: likesViewModel.likesTab)
                    }
                } else {
                    ProgressView()
                }
                Spacer()
            }
            .onAppear(perform: likesViewModel.subscripe)
            
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        SortMenuSections(activeSort: $likesViewModel.activeSort, sortOrder: $likesViewModel.sortOrder)
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                    }
                }
            }
            .navigationTitle(Tab.likes.title)
            .navigationBarTitleDisplayMode(.inline)
        }


    }
    private var emptyStateContent: some View {
        Group {
            Text(likesViewModel.likesTab.emptyText)
                .appFont(size: 30, textWeight: .bold)
                .multilineTextAlignment(.center)

            Button {
                withAnimation {
                    activeTabViewTab = .swipe
                }
            } label: {
                Text(Strings.goToSwipe)
                    .appButtonStyle()
            }
        }
        .padding()
    }

}

#Preview {
    LikesView(activeTabViewTab: .constant(.likes))
}
