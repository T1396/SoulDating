//
//  SettingsElement.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 10.06.24.
//

import SwiftUI

struct SettingsElement: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var showEditSheet = false
    @Environment(\.colorScheme) var colorScheme
    
    var item: ProfileItem
    var body: some View {
        Button {
            showEditSheet.toggle()
        } label: {
            HStack {
                VStack(alignment: .leading) {
                    Text(item.id)
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                    Text(item.value)
                        .font(.footnote)
                        .foregroundStyle(.gray.opacity(0.9))
                }
                Spacer()
                Image(systemName: "chevron.right")
            }
        }
        .sheet(isPresented: $showEditSheet) {
            DetailEditView(profileItem: item)
                .presentationDetents([.medium])
        }
        
    }
}
#Preview {
    SettingsElement(item: .name("Klaus"))
        .environmentObject(UserViewModel())
}
