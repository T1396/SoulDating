//
//  SettingsElement.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 10.06.24.
//

import SwiftUI

struct SettingsElement<Content>: View where Content: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @Environment(\.colorScheme) var colorScheme
    
    let title: String
    var value: String?
    var icon: String?
    @ViewBuilder var content: () -> Content
    
    @State private var showSheet = false
    
    var valueText: String {
        if let value, !value.isEmpty {
            value
        } else {
            "Not specified"
        }
    }
    
    var body: some View {
        Button(action: { showSheet.toggle() }) {
            HStack {
                if let icon {
                    Image(systemName: icon)
                        .font(.title2)
                        .frame(width: 40)
                }
                
                VStack(alignment: .leading) {
                    Text(title)
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                    Text(valueText)
                        .font(.footnote)
                        .foregroundStyle(.gray.opacity(0.9))

                }
                Spacer()
                Image(systemName: "chevron.right")
            }
        }
        .sheet(isPresented: $showSheet, content: content)
     
        
    }
}
#Preview {
    SettingsElement(title: "Name", value: "Klaus", icon: "trash", content: {
        Text("Hallo")
    })
        .padding()
        .environmentObject(UserViewModel())
}
