//
//  MessageView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 28.06.24.
//

import SwiftUI

struct MessageView: View {
    let message: Message
    let isCurrentUser: Bool
    
    let gradient = LinearGradient(gradient: Gradient(colors: [Color.cyan.opacity(0.3), Color.blue.opacity(0.4)]), startPoint: .topLeading, endPoint: .bottomTrailing)
    
    var body: some View {
        HStack {
            if isCurrentUser {
                Spacer()
            }
            VStack(alignment: .trailing, spacing: 0) {
                Text(message.content)
                    .appFont(size: 14)
                Text(message.timestamp.toTimeString())
                    .appFont(size: 9)
                    .frame(minWidth: 30, alignment: .trailing)
                    .offset(x: 4)
            }
            .padding([.top, .horizontal])
            .padding(.bottom, 10)
            .background(gradient, in: RoundedRectangle(cornerRadius: 20))
            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
            .foregroundColor(.primary)
            
            if !isCurrentUser {
                Spacer()
            }
        }
        .transition(.asymmetric(insertion: .scale, removal: .opacity))
    }
}

#Preview {
    MessageView(message: Message(senderId: "1", receiverId: "2", content: "Du kleidsadaslkjöd", timestamp: .now, isRead: true), isCurrentUser: true)
}
