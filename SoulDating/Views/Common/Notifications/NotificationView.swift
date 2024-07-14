//
//  NotificationView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 25.06.24.
//

import SwiftUI

/* credits https://medium.com/kerege/swiftui-custom-notification-view-with-animation-f2911c70d6e3 */
struct NotificationView2: View {
    
    enum AnimationStateType: Double {
        case hide = 0
        case show =  1
    }
    @Binding var text: String?
    // 'state' property stores state of view (hidden or not)
    @State private var state: AnimationStateType = .hide
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack {
                    Text(text ?? "")
                        .foregroundStyle(.white)
                        .appFont(size: 18, textWeight: .semibold)
                }
            }
            .padding(30)
            .background(.black)
            .cornerRadius(20)
            .position(getPosition(with: geo))
            .frame(maxWidth: max(0, geo.size.width - 64))
            .opacity(state.rawValue)
        }
        .onChange(of: text, { _, newValue in
            if newValue == nil || newValue?.isEmpty == true {
                hideNotification()
            } else if newValue != nil {
                showNotification()
            }
        })
    }
    
    // This function helps us to define position in differen state.
    // 'GeometryProxy' has information about screen size
    private func getPosition(with proxy: GeometryProxy) -> CGPoint {
        switch state {
        case .hide:
            return CGPoint(x: proxy.size.width / 2, y: -proxy.safeAreaInsets.top)
        case .show:
            return CGPoint(x: proxy.size.width / 2, y: proxy.safeAreaInsets.top)
        }
    }
    
    private func showNotification() {
        withAnimation {
            state = .show
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                withAnimation {
                    self.state = .hide
                }
            }
        }
    }
    
    private func hideNotification() {
        withAnimation {
            state = .hide
        }
    }
}

#Preview {
    NotificationView2(text: .constant("kdlsado"))
}
