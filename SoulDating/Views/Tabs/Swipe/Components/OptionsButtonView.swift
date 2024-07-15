//
//  OptionsButtonView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 14.06.24.
//

import SwiftUI

struct OptionsButtonView: View {
    @Binding var showOptionsSheet: Bool
    let user: FireUser

    var body: some View {
        Button {
            showOptionsSheet.toggle()
        } label: {
            Image(systemName: "ellipsis")
                .font(.title)
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    OptionsButtonView(showOptionsSheet: .constant(true), user: FireUser(id: "Hello", name: "Hallo", registrationDate: .now))
}
