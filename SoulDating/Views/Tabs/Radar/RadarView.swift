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
    // @StateObject private var radarViewModel: RadarViewModel
    @StateObject private var radarVm = RadarViewModel()

    @Binding var activeTabViewTab: Tab


    private let gridItems = [ GridItem(.flexible()), GridItem(.flexible()) ]
    
    // MARK: init


    init(activeTabViewTab: Binding<Tab>) {
        print("RadarView initialized")
        self._activeTabViewTab = activeTabViewTab
    }

    // MARK: body
    var body: some View {
        NavigationStack {
            Group {
                if !radarVm.filteredSortedUsers.isEmpty {
                    GeometryReader { geometry in
                        let width = (geometry.size.width - 40) / 2
                        let height = width * 4 / 3

                        ScrollView {
                            LazyVGrid(columns: gridItems, content: {
                                ForEach(radarVm.filteredSortedUsers) { user in
                                    ImageWithGradientAndName(user: user, distance: radarVm.distance(to: user.location), minWidth: width, minHeight: height)
                                }
                            }).padding(.horizontal)
                        }
                    }

                } else {
                    Text(Strings.radarNoUsers)
                        .appFont(size: 22, textWeight: .bold)
                        .padding(.horizontal, 40)

                    Button {
                        withAnimation {
                            activeTabViewTab = .profile
                        }
                    } label: {
                        Text(Strings.goToProfileTab)
                            .appButtonStyle()
                    }
                }
            }
            .onAppear(perform: radarVm.updateUserAndRefetchIfNeeded)
            .toolbar {
                ToolbarItem {

                    Menu {
                        SortMenuSections(activeSort: $radarVm.activeSort, sortOrder: $radarVm.sortOrder)
                        Section(Strings.filterBy) {
                            
                            ForEach(RadarFilter.allCases) { filter in
                                Menu(filter.title) {
                                    ForEach(filter.allOptions, id: \.self) { option in
                                        Button {
                                            withAnimation {
                                                radarVm.toggleFilterOption(filter, optionRawValue: option.rawValue)
                                            }
                                        } label: {
                                            Label(option.title, systemImage: radarVm.isOptionSelected(filter, option: option.rawValue) ? "checkmark.circle.fill" : "circle")
                                        }
                                    }
                                    
                                }
                            }
                        }
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                    }
                    .menuActionDismissBehavior(.disabled)
                }
            }
            .navigationTitle(Tab.radar.title)
        }
    }
}


#Preview {
    RadarView(activeTabViewTab: .constant(.radar))
        .environmentObject(UserViewModel())
}
