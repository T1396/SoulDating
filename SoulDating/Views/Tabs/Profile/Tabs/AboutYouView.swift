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
    @State private var activeSheetElement: AboutYouItem?
    
    // MARK: body
    var body: some View {
        Form {
            ForEach(AboutYouSection.allCases) { section in
                
                Section(section.displayName) {
                    ForEach(section.items(user: userViewModel.user)) { item in
                        Button(action: {
                            self.activeSheetElement = item
                            self.isSheetPresented = true
                        }) {
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
    AboutYouView()
        .environmentObject(UserViewModel())
}
