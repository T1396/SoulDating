//
//  EditDateView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 10.06.24.
//

import SwiftUI

struct EditDateView: View {
    var date: Date
    var body: some View {
        Text("Bearbeiten Datum: \(date)")
    }
}

#Preview {
    EditDateView(date: .now)
}
