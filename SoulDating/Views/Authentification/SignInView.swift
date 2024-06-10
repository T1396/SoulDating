//
//  SignInView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 05.06.24.
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var showSignInSheet = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Button("Start") { showSignInSheet = true }
                    .padding()
                    .padding(.horizontal)
                    .background(.red)
                    .clipShape(Capsule())
            }
            .sheet(isPresented: $showSignInSheet) {
                SignInSheet()
                    .presentationDetents([.medium])
            }
        }
    }
}

#Preview {
    SignInView()
        .environmentObject(UserViewModel())
}


