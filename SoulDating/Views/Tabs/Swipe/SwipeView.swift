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
    @StateObject private var swipeViewModel: SwipeViewModel
    
    init(user: User) {
        self.user = user
        self._swipeViewModel = StateObject(wrappedValue: SwipeViewModel(user: user))
    }
    @State private var swipeSheet: SwipeViewSheet?
    @State private var activeCardID: String?  // State to track active card when options sheet is opened
    private let user: User
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                if swipeViewModel.noMoreUsersAvailable {
                    noUserOptionsAndText
                        .padding()
                } else {
                    ForEach(swipeViewModel.allSwipeableUsers) { user in
                        SwipeCardView(swipeViewModel: swipeViewModel, targetUser: user, activeCardID: $activeCardID)
                            .onTapGesture {
                                activeCardID = user.id
                            }
                            .shadow(color: .black.opacity(0.5), radius: 2, x: 0.0, y: 0.0)
                            .padding()
                            .clipped()
                    }
                }
            }
            .sheet(item: $swipeSheet) { sheet in
                switch sheet {
                case .editRadiusOrLocation:
                    if let location = userViewModel.user.location {
                        EditLocationRangeView(location: location, user: user)
                    }
                case .editAgeRange:
                    let item = PreferencesItem.ageRange(nil)
                    EditAgeRangeView(title: item.title, agePreference: userViewModel.agePreferences, path: item.firebaseFieldName)
                        .presentationDetents([.medium])
                    
                }
            }
            .alert(swipeViewModel.alertTitle, isPresented: $swipeViewModel.showAlert, actions: {
                Button("Cancel", role: .cancel, action: swipeViewModel.dismissAlert)
                Button("Retry", role: .destructive, action: {})
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
                swipeViewModel.configure(with: userViewModel)
                swipeViewModel.fetchUsersNearby()
            }
        }
    }
    
    private var noUserOptionsAndText: some View {
        VStack {
            Text("Unfortunately there are no other users in your area...")
                .appFont(size: 30, textWeight: .bold)
                .multilineTextAlignment(.center)
            
            
            Button {
                swipeSheet = .editRadiusOrLocation
            } label: {
                Text("Update Location or radius?")
                    .appFont(textWeight: .bold)
                    .appButtonStyle()
            }
            
            Button {
                swipeSheet = .editAgeRange
            } label: {
                Text("Or change the age span?")
                    .appFont(textWeight: .bold)
                    .appButtonStyle()
            }
        }
    }
}

#Preview {
    SwipeView(user: User(id: "johasd", name: "John Boenro" ,registrationDate: .now))
        .environmentObject(UserViewModel())
}
