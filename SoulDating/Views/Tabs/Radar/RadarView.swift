//
//  RadarView.swift
//
//
//  Created by Philipp Tiropoulos on 10.06.24.
//

import SwiftUI






struct RadarView: View {
    // MARK: properties
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var chatVm: ChatViewModel
    // @StateObject private var radarViewModel: RadarViewModel
    @StateObject private var mockVm: MockRadarViewModel
    @State private var navigateToUserProfile = false
    
    private let gridItems = [ GridItem(.flexible()), GridItem(.flexible()) ]
    
    // MARK: init
    init(user: FireUser) {
        // self._radarViewModel = StateObject(wrappedValue: RadarViewModel(user: user))
        self._mockVm = StateObject(wrappedValue: MockRadarViewModel(user: user))
    }

    // MARK: body
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                
                let width = (geometry.size.width - 40) / 2
                let height = width * 4 / 3
                ScrollView {
                    LazyVGrid(columns: gridItems, content: {
                        ForEach(mockVm.filteredUsers) { user in
                            
                            
                            NavigationLink {
                                let chatId = chatVm.returnChatIdIfExists(for: user.id)
                                MessageAndProfileView(contentType: .profile, targetUser: user, chatId: chatId, image: .constant(nil))
                            } label: {
                                ImageWithGradientAndName(user: user, distance: mockVm.distance(to: user.location), minWidth: width, minHeight: height)
                            }
//
//                            ImageWithGradientAndName(user: user, distance: mockVm.distance(to: user.location), minWidth: width, minHeight: height)
//                                .onTapGesture {
//                                    navigateToUserProfile = true
//                                }
//                                .navigationDestination(isPresented: $navigateToUserProfile, destination: {
//                                    OtherUserProfileView(showProfile: $navigateToUserProfile, image: .constant(nil), targetUser: user, user: userViewModel.user)
//                                        .navigationBarBackButtonHidden()
//                                })
                        }
                    }).padding(.horizontal)
                }
            }

            .toolbar {
                ToolbarItem {
                    Menu {
                        
                        Section("Sort by") {
                            ForEach(RadarSortOption.allCases) { sortOption in
                                Button {
                                    mockVm.setSortOption(sortOption)
                                } label: {
                                    Label(sortOption.title, systemImage: mockVm.isSortSelected(sortOption) ? "checkmark.circle.fill" : "circle")
                                }
                            }
                        }
                        
                        Section("Filter by") {
                            
                            ForEach(RadarFilter.allCases) { filter in
                                Menu(filter.title) {
                                    ForEach(filter.allOptions, id: \.self) { option in
                                        Button {
                                            mockVm.toggleFilterOption(filter, option: option.rawValue)
                                            print("daskldkal")
                                        } label: {
                                            Label(option.title, systemImage: mockVm.isOptionSelected(filter, option: option.rawValue) ? "checkmark.circle.fill" : "circle")
                                        }
                                    }
                                    
                                }
                            }
                            
                        }
                        
                        Button("more") {
                            // MARK: TODO
                        }
                        
                        
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                    }
                    .menuActionDismissBehavior(.disabled)
                }
            }
            .navigationTitle(Tab.radar.title)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


#Preview {
    RadarView(user: FireUser(id: "1", name: "Hannes"))
        .environmentObject(UserViewModel())
}
