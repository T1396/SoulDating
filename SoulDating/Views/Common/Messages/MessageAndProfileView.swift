//
//  MessageAndProfileView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 03.07.24.
//

import SwiftUI

struct MessageAndProfileView: View {
    enum ContentType { case message, profile }
    @State private var contentType: ContentType
    let targetUser: FireUser
    let chatId: String?
    @Binding var userImage: Image?
    
    
    init(contentType: ContentType = .message, targetUser: FireUser, chatId: String?, image: Binding<Image?>) {
        self._contentType = State(initialValue: contentType)
        self.targetUser = targetUser
        self.chatId = chatId
        self._userImage = image
    }
    
    var body: some View {
        switch contentType {
        case .message:
            WriteMessageView(targetUser: targetUser, chatId: chatId, contentType: $contentType)
               
        case .profile:
            OtherUserProfileView(image: $userImage, targetUser: targetUser, contentType: $contentType)
        }

    }
}

#Preview {
    MessageAndProfileView(targetUser: FireUser(id: "1"), chatId: "2", image: .constant(nil))
}
