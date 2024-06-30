//
//  PreferencesView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 20.06.24.
//

import SwiftUI

struct PreferencesView: View {
    // MARK: properties
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var isSheetPresented = false
    @State private var activeSheetElement: PreferencesItem?
    
    init() {
        print("View new initialized")
    }
    
    var body: some View {
        Form {
            ForEach(PreferencesSection.allCases) { section in
                
                Section(section.displayName) {
                    
                    
                    ForEach(section.items(user: userViewModel.user)) { item in
                        
                        Button {
                            self.activeSheetElement = item
                            self.isSheetPresented = true
                        } label: {
                            SettingsElement(title: item.title, value: item.valueString, icon: item.icon)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: Binding(
            get: { isSheetPresented },
            set: { isSheetPresented = $0 }
        ), onDismiss: { activeSheetElement = nil }, content: {
            activeSheetElement?.editView(user: userViewModel.user)
                .presentationDetents([.medium, .large])
        })
        .listStyle(.insetGrouped)
    }
}


#Preview {
    PreferencesView()
}
