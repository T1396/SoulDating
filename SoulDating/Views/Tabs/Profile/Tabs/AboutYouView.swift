//
//  AboutYouView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 20.06.24.
//

import SwiftUI

struct AboutYouView: View {
    // MARK: properties
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var isSheetPresented = false
    @State private var activeSheet: (any AboutYouItemProtocol)?

    // MARK: body
    var body: some View {
        Form {
            ForEach(AboutYouSection.allCases) { section in
                Section(section.displayName) {
                    ForEach(section.items(), id: \.title) { item in
                        Button(action: {
                            activeSheet = item
                            isSheetPresented = true
                        }, label: {
                            ProfileItemRow(title: item.title, value: item.value(user: $userViewModel.user) ?? "", systemName: item.icon)
                        })
                    }
                }
            }
        }
        .sheet(isPresented: Binding(
            get: { isSheetPresented },
            set: { isSheetPresented = $0 }
        ), onDismiss: { activeSheet = nil }, content: {
            activeSheet?.editView(user: $userViewModel.user)
                .presentationDetents([.medium, .large])
        })

        .listStyle(.insetGrouped)
    }
}


#Preview {
    AboutYouView()
        .environmentObject(UserViewModel())
}
