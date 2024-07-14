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
            ZStack {
                if let url = Bundle.main.url(forResource: "signVideo", withExtension: "mp4") {                FullScreenVideoView(url: url)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .ignoresSafeArea(edges: .all)
                        .onAppear {
                            print("videossss")
                        }
                } else {
                    Color.clear
                        .onAppear {
                            print("dksladklaskdlskdlak")
                        }
                }
                Button(action: showSheet) {
                    Text(Strings.start)
                        .frame(minWidth: 120)
                        .appButtonStyle(textSize: 20, cornerRadius: 90)
                }
                .frame(maxHeight: .infinity, alignment: .bottom)

            }
            .sheet(isPresented: $showSignInSheet) {
                SignInSheet(isPresented: $showSignInSheet)
                    .presentationDetents([.medium, .large])
            }
        }
    }

    private func showSheet() {
        showSignInSheet = true
    }
}

#Preview {
    SignInView()
        .environmentObject(UserViewModel())
}
