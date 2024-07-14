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
    @Binding var user: FireUser

    @State private var isSheetPresented = false
    @State private var activeSheet: (any AboutYouItemProtocol)?
    
    // MARK: init
    init() {
        _user = Binding(get: { UserService.shared.user }, set: { UserService.shared.user = $0 })
    }

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
                            ProfileItemRow(title: item.title, value: item.value(user: $user) ?? "", systemName: item.icon)
                        })
                    }
                }
            }
        }
        .sheet(isPresented: Binding(
            get: { isSheetPresented },
            set: { isSheetPresented = $0 }
        ), onDismiss: { activeSheet = nil }, content: {
            activeSheet?.editView(user: $user)
                .presentationDetents([.medium, .large])
        })

        .listStyle(.insetGrouped)
    }
}


#Preview {
    AboutYouView()
        .environmentObject(UserViewModel())
}
