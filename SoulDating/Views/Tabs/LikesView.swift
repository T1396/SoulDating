//
//  LikesView.swift
//  
//
//  Created by Philipp Tiropoulos on 10.06.24.
//

import SwiftUI

struct LikesView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Your latest likes")

            }
            .navigationTitle("Likes")
        }
    }
}

#Preview {
    LikesView()
}
