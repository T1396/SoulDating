//
//  LikesView.swift
//  
//
//  Created by Philipp Tiropoulos on 10.06.24.
//

import SwiftUI

struct LikesView: View {
    var body: some View {
        VStack {
            Text("Your latest likes")
                .appFont()
        }
        .navigationTitle(Tab.likes.title)
        .navigationBarTitleDisplayMode(.inline)
        
    }
    
}

#Preview {
    LikesView()
}
