//
//  SwipeView.swift
//
//
//  Created by Philipp Tiropoulos on 10.06.24.
//
import SwiftUI

struct SwipeView: View {
    // MARK: properties
    @StateObject private var swipeViewModel = SwipeViewModel()
    @State private var swipeSheet: SwipeViewSheet?
    @State private var activeCardID: String?  // State to track active card when options sheet is opened
    @Binding var user: FireUser

    

    // MARK: init
    init() {
        // get user binding from userservice
        _user = Binding(get: { UserService.shared.user }, set: { UserService.shared.user = $0 })
    }

    var body: some View {
        NavigationStack {
            ZStack {
                if swipeViewModel.noMoreUsersAvailable {
                    noUserOptionsAndText
                        .padding()
                } else {
                    ForEach(swipeViewModel.displayedUsers.reversed()) { user in
                        SwipeCardView(swipeUserVm: user, activeCardID: $activeCardID, onMessageOrProfileCoverClosed: checkForReportedUser)
                            .onTapGesture {
                                activeCardID = user.otherUser.id
                            }
                            .shadow(color: .black.opacity(0.5), radius: 2, x: 0.0, y: 0.0)
                            .padding()
                            .clipped()
                    }
                }
                
                // show matches
                if let userMatch = swipeViewModel.userMatch {
                    MatchCardView(currentMatch: $swipeViewModel.userMatch, currentUser: swipeViewModel.user, otherUser: userMatch)
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
                        agePreference: $user.preferences.agePreferences,
                        path: item.firebaseFieldName
                    )
                    .environmentObject(EditUserViewModel())
                    .presentationDetents([.medium])
                }
            }
            .alert(swipeViewModel.alertTitle, isPresented: $swipeViewModel.showAlert, actions: {
                if let retryAction = swipeViewModel.onAcceptAction {
                    Button(Strings.cancel, role: .cancel, action: swipeViewModel.dismissAlert)
                    Button(Strings.retry, role: .destructive, action: retryAction)
                } else {
                    Button(Strings.cancel, role: .cancel, action: swipeViewModel.dismissAlert)
                }
            }, message: {
                Text(swipeViewModel.alertMessage)
            })

            .navigationTitle(Tab.swipe.title)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: swipeViewModel.subscribe) // refetches user when changes to user prefs were made and listener for likes
            .onDisappear(perform: swipeViewModel.unsubscribe)
        }
    }

    // MARK: views
    private var noUserOptionsAndText: some View {
        VStack {
            Text(Strings.noSwipeUsers)
                .appFont(size: 24, textWeight: .bold)
                .multilineTextAlignment(.center)

            Button(action: fetchUsers) {
                Text(swipeViewModel.isFetchingUsers ? Strings.fetchingUser : Strings.fetchAgain)
                    .appButtonStyle(fullWidth: true)
                    .animation(.smooth, value: swipeViewModel.isFetchingUsers)
            }

            Button {
                swipeSheet = .editRadiusOrLocation
            } label: {
                Text(Strings.updateLocationRadius)
                    .appButtonStyle(fullWidth: true)
            }

            Button {
                swipeSheet = .editAgeRange
            } label: {
                Text(Strings.changeAgeSpan)
                    .appButtonStyle(fullWidth: true)
            }
        }
        .padding(.horizontal, 40)
        .frame(maxWidth: .infinity)
    }

    // MARK: functions
    private func checkForReportedUser() {
        withAnimation {
            swipeViewModel.checkForReportedUser()
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
