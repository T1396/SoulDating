//
//  SortMenuView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 12.07.24.
//

import SwiftUI

/// Sort Menu Sections to use in Likes and RadarView as MenuSections
struct SortMenuSections: View {
    // MARK: properties
    @Binding var activeSort: UserSortOption
    @Binding var sortOrder: SortOrder

    // MARK: body
    var body: some View {
        Section(Strings.sortBy) {
            ForEach(UserSortOption.allCases) { sortOption in
                Button {
                    withAnimation {
                        activeSort = sortOption
                    }
                } label: {
                    Label(sortOption.title, systemImage: activeSort == sortOption ? "checkmark.circle.fill" : "circle")
                }
            }
        }
        Section(Strings.sortOrder) {
            Button {
                withAnimation {
                    sortOrder = sortOrder == .ascending ? .descending : .ascending
                }
            } label: {
                Label(Strings.toggleSort, systemImage: sortOrder.icon)
            }
        }
    }
}
