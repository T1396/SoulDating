//
//  SwipeView.swift
//
//
//  Created by Philipp Tiropoulos on 10.06.24.
//
import SwiftUI




struct SwipeView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var chatViewModel: ChatViewModel
    @StateObject private var swipeViewModel = SwipeViewModel()
    @State private var swipeSheet: SwipeViewSheet?
    @State private var activeCardID: String?  // State to track active card when options sheet is opened


    var body: some View {
        NavigationStack {
            ZStack {
                if swipeViewModel.noMoreUsersAvailable {
                    noUserOptionsAndText
                        .padding()
                } else {
                    ForEach(swipeViewModel.displayedUsers.reversed()) { userVm in
                        print("ALL DISPLAYED CARDS: \(swipeViewModel.displayedUsers.map { $0.otherUser.name })")
                        return SwipeCardView(swipeUserVm: userVm, activeCardID: $activeCardID)
                            .onTapGesture {
                                activeCardID = userVm.otherUser.id
                            }
                            .shadow(color: .black.opacity(0.5), radius: 2, x: 0.0, y: 0.0)
                            .padding()
                            .clipped()
                    }
                }

                if let userMatch = swipeViewModel.userMatch {
                    MatchCardView(currentMatch: $swipeViewModel.userMatch, currentUser: userViewModel.user, otherUser: userMatch)
                        .transition(.asymmetric(insertion: .push(from: .trailing), removal: .slide))
                        .zIndex(5) // holds the card in foreground
                }
            }
            .sheet(item: $swipeSheet) { sheet in
                switch sheet {
                case .editRadiusOrLocation:
                    EditLocationRangeView()
                case .editAgeRange:
                    let item = DatingPreferenceItem.ageRange
                    EditAgeRangeView(
                        title: item.title,
                        agePreference: $userViewModel.user.preferences.agePreferences,
                        path: item.firebaseFieldName
                    )
                    .presentationDetents([.medium])
                }
            }
            .alert(swipeViewModel.alertTitle, isPresented: $swipeViewModel.showAlert, actions: {
                if let retryAction = swipeViewModel.onAcceptAction {
                    Button("Cancel", role: .cancel, action: swipeViewModel.dismissAlert)
                    Button("Retry", role: .destructive, action: retryAction)
                } else {
                    Button("Cancel", role: .cancel, action: swipeViewModel.dismissAlert)
                }
            }, message: {
                Text(swipeViewModel.alertMessage)
            })

            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: userViewModel.logout) {
                        Image(systemName: "power")
                    }
                }
            }

            .navigationTitle(Tab.swipe.title)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                swipeViewModel.subscribe()
            }
            .onDisappear {
                swipeViewModel.unsubscribe()
            }
        }
    }

    private var noUserOptionsAndText: some View {
        VStack {
            Text("Unfortunately there are no other users in your area...")
                .appFont(size: 30, textWeight: .bold)
                .multilineTextAlignment(.center)

            Button(action: fetchUsers) {
                Text(swipeViewModel.isFetchingUsers ? "Fetching new users..." : "Try to fetch users again")
                    .appFont(textWeight: .bold)
                    .appButtonStyle(fullWidth: true)
                    .animation(.smooth, value: swipeViewModel.isFetchingUsers)
            }

            Button {
                swipeSheet = .editRadiusOrLocation
            } label: {
                Text("Update Location or radius?")
                    .appFont(textWeight: .bold)
                    .appButtonStyle(fullWidth: true)
            }

            Button {
                swipeSheet = .editAgeRange
            } label: {
                Text("Or change the age span?")
                    .appFont(textWeight: .bold)
                    .appButtonStyle(fullWidth: true)
            }
        }
    }

    private func fetchUsers() {
        withAnimation {
            swipeViewModel.fetchUsersNearby()
        }
    }
}

#Preview {
    SwipeView()
        .environmentObject(UserViewModel())
}
