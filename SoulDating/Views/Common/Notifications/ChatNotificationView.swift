//
//  ChatNotificationView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 06.07.24.
//

import SwiftUI

struct ChatNotificationView: View {

    enum AnimationStateType: Double {
        case hide = 0
        case show =  1
    }
    @Binding var chatNotification: ChatNotification?
    // 'state' property stores state of view (hidden or not)
    @State private var state: AnimationStateType = .hide

    var body: some View {
        GeometryReader { geo in
            ZStack {
                HStack {
                    RoundedWebImage(imageUrl: chatNotification?.senderImageUrl, width: 50, height: 50)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(chatNotification?.senderName ?? "Anonymous")
                            .appFont(size: 14, textWeight: .bold)
                            .foregroundStyle(.white)

                        Text(chatNotification?.message ?? "")
                            .foregroundStyle(.white)
                            .appFont(size: 12, textWeight: .semibold)
                            .lineLimit(2)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding()
            .frame(width: max(0, geo.size.width - 48))
            .background(.black)
            .cornerRadius(20)
            .position(getPosition(with: geo))
            .opacity(state.rawValue)
        }
        .onChange(of: chatNotification, { _, newValue in
            if newValue != nil {
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
                    self.chatNotification = nil
                }
            }
        }
    }
}


#Preview {
    ChatNotificationView(chatNotification: .constant(ChatNotification(message: "dsaklkl", senderName: "Hosua", timestamp: .now, senderImageUrl: "dkslakdla")))
}
