//
//  SettingsElement.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 10.06.24.
//

import SwiftUI

struct SettingsElement: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @Environment(\.colorScheme) var colorScheme
    
    let title: String
    var value: String?
    var icon: String?
    
    var valueText: String {
        if let value, !value.isEmpty {
            value
        } else {
            "Not specified"
        }
    }
    
    var body: some View {
        HStack(spacing: 16) {
            if let icon {
                HStack {
                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundStyle(.white)
                }
                .frame(width: 30, height: 30)
                .padding(2)
                .background(.accent.opacity(0.6), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
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
                .padding(.trailing, 6)
            
        }
    }
}

#Preview {
    SettingsElement(title: "Name", value: "Klaus", icon: "trash")
        .padding()
    .environmentObject(UserViewModel())
}
