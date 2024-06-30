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
    @StateObject private var radarViewModel: RadarViewModel
    @StateObject private var mockVm = MockRadarViewModel(user: User(id: "-1", name: "Josef", location: LocationPreference(latitude: 40.829643, longitude: -73.926175, name: "Bronx", radius: 5)))
    
    private let gridItems = [ GridItem(.flexible()),
                              GridItem(.flexible())
    ]
    
    // MARK: init
    init(user: User) {
        self._radarViewModel = StateObject(wrappedValue: RadarViewModel(user: user))
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
                            ImageWithGradientAndName(user: user, distance: mockVm.distance(to: user.location), minWidth: width, minHeight: height)
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
                                .menuActionDismissBehavior(.disabled)
                            }
                            
                        }
                        
                        Button("more") {
                            
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
    RadarView(user: User(id: "1", name: "Hannes"))
        .environmentObject(UserViewModel())
}
