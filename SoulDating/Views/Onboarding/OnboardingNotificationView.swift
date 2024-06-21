//
//  OnboardingNotificationView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 15.06.24.
//

import Foundation
import SwiftUI

struct OnboardingNotificationView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var showingAlert = false
    @State private var navigate = false
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                Image(systemName: "bell.square.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(.cyan)
                    .padding(.top, 24)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Text("Turn on Notifications?")
                    .appFont(size: 36, textWeight: .extrabold)
                
                Text("Turn on your notifications so that you will be informed when you have new message matches or likes")
                    .appFont(size: 24, textWeight: .medium)
                
                
                Text("You can turn off the notifications in the settings at each time.")
                    .appFont(size: 14, textWeight: .light)
                
                Spacer()
                
                Button {
                    requestNotification()
                } label: {
                    HStack {
                        Text("Turn on notifications")
                            .foregroundStyle(.background)
                        Image(systemName: "bell.fill")
                            .foregroundStyle(.background)
                    }
                    .frame(maxWidth: .infinity)
                    .appButtonStyle()
                }
                
                
                Button {
                    navigate.toggle()
                } label: {
                    Text("Not now")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .appButtonStyle(type: .secondary)
                }
                
            }
            .padding(20)
            .padding(.bottom, 16)
            
            .navigationDestination(isPresented: $navigate) {
                OnboardingLocationView(viewModel: viewModel)
            }
        }
    }
    
    private func requestNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                // Handle the error here.
                print("Error: \(error.localizedDescription)")
            }
            
            DispatchQueue.main.async {
                if granted {
                    print("notifications allowed")
                    navigate.toggle()
                }
            }
        }
    }
}

#Preview {
    OnboardingNotificationView(viewModel: OnboardingViewModel())
}
