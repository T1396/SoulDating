//
//  EditListView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 10.06.24.
//

import SwiftUI

struct EditListView: View {
    var items: [String]
    var body: some View {
        ForEach(items, id: \.self) { item in
            Text(item)
        }
    }
}

#Preview {
    EditListView(items: ["Hallo", "Hallo"])
}
