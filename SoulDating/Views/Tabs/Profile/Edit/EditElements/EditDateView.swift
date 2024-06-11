//
//  EditDateView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 10.06.24.
//

import SwiftUI
import Firebase

struct EditDateView: View {
    var date: Timestamp
    var body: some View {
        Text("Bearbeiten Datum: \(date)")
    }
}

#Preview {
    EditDateView(date: .init(date: .now))
}
