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
    
    init(user: User) {
        print(user)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(PreferencesSection.allCases) { section in
                   
                    Text(section.displayName)
                        .appFont(size: 20, textWeight: .bold)
                        .padding(.horizontal)
                    
                    ForEach(section.items(user: userViewModel.user)) { item in
                        
                        SettingsElement(title: item.title, value: item.valueString) {
                            item.editView(user: userViewModel.user)
                                .presentationDetents([.medium, .large])
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 6)
                    }
                }
            }
        }
    }
}

#Preview {
    PreferencesView(user: User(id: "djsak", name: "klausd"))
}
