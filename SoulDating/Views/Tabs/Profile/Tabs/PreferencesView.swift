//
//  PreferencesView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 20.06.24.
//

import SwiftUI

struct PreferencesView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var showSheet = false
    @StateObject private var prefVm: PreferencesViewModel
    
    init(user: User) {
        self._prefVm = StateObject(wrappedValue: PreferencesViewModel(user: user))
    }
    
    var body: some View {
        LazyVStack {
            ForEach(PreferencesSection.allCases) { section in
                ForEach(section.items(user: userViewModel.user)) { item in
                    
                    SettingsElement(title: item.title, value: item.valueString, content: {
                        item.view(user: userViewModel.user)
                    })
                        .padding(.horizontal)
                        .padding(.vertical, 6)
                }
            }
        }
    }
}

#Preview {
    PreferencesView(user: User(id: "djsak", name: "klausd"))
}
