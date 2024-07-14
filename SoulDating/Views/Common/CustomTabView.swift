//
//  CustomTabView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 11.07.24.
//

import SwiftUI

protocol TabEnum: CaseIterable, Equatable, Identifiable where AllCases: RandomAccessCollection, AllCases.Element == Self {
    var title: String { get }
}

struct CustomTabView<TabOptions: TabEnum>: View {
    @Binding var activeTab: TabOptions
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabOptions.allCases) { tab in
                VStack(spacing: 0) {
                    Text(tab.title)
                        .appFont(size: 12, textWeight: activeTab == tab ? .semibold : .regular)
                        .padding(6)
                        .padding(.top, 4)
                        .foregroundStyle(activeTab == tab ? .accent : .primary)
                        .frame(maxWidth: .infinity)
                        .background(.blue.opacity(0.000000001))
                        .onTapGesture {
                            withAnimation {
                                activeTab = tab
                            }
                        }
                    Rectangle()
                        .fill(activeTab == tab ? .accent : .clear)
                        .frame(height: 4)
                }

            }
        }
    }
}
