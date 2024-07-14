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
    @Binding var progress: Double
    @Binding var stepIndex: Int

    @State private var showingAlert = false
    @State private var navigate = false
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                
                Image(systemName: "bell.square.fill")
                    .onboardingIconStyle()

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
                    .appButtonStyle(fullWidth: true)
                }
                
                Button(action: goToNextPage) {
                    Text(Strings.notNow)
                        .appButtonStyle(type: .secondary, fullWidth: true)
                }
                
            }
            .padding(20)
            .padding(.bottom, 16)

            .onAppear {
                withAnimation {
                    progress = 0.8
                }
            }
        }
    }
    // MARK: functions
    private func goToNextPage() {
        withAnimation {
            stepIndex += 1 // go to next onboarding page
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
                    // navigate to next onboarding page
                    goToNextPage()
                }
            }
        }
    }
}

#Preview {
    OnboardingNotificationView(viewModel: OnboardingViewModel(), progress: .constant(0.8), stepIndex: .constant(2))
        .environmentObject(UserViewModel())
}
