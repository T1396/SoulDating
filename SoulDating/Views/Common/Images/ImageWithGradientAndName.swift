//
//  ImageWithGradientAndName.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 24.06.24.
//

import SwiftUI

struct ImageWithGradientAndName: View {
    enum TextSize: CGFloat { case small = 12, medium = 16, large = 21 }
    
    
    // MARK: properties
    let user: FireUser
    let distance: String?
    var minWidth: CGFloat = 100
    var minHeight: CGFloat = 133
    var textSize: TextSize = .large

    @State private var navigateToUser = false

    // MARK: computed properties
    var safeWidth: CGFloat {
        max(0, minWidth)
    }
    
    var safeHeight: CGFloat {
        max(0, minHeight)
    }
    
    // MARK: body
    var body: some View {
        Button {
            withAnimation {
                navigateToUser = true
            }
        } label: {
            ZStack(alignment: .bottom) {
                UserImage(url: user.profileImageUrl, minWidth: safeWidth, minHeight: minHeight)

                LinearGradient(colors: [.clear, .black], startPoint: .center, endPoint: .bottom)

                VStack {
                    
                    if let distance {
                        Text(distance)
                            .appFont(size: 10)
                            .foregroundStyle(.white)
                            .itemBackgroundStyleAlt(.black.opacity(0.6), padding: 6, cornerRadius: 20)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    Spacer()
                    HStack(spacing: 4) {
                        Text(user.nameAgeString)
                            .appFont(size: textSize.rawValue, textWeight: .bold)
                            .foregroundStyle(.white)
                        Image(systemName: "circle.fill")
                            .foregroundStyle(.green)

                    }
                }

                .offset(x: 5)
                .padding(6)
            }
        }
        .fullScreenCover(isPresented: $navigateToUser) {
            let chatId = ChatService.shared.returnChatIdIfExists(for: user.id)
            MessageAndProfileView(contentType: .profile, targetUser: user, chatId: chatId, image: .constant(nil))
        }
        .frame(minWidth: safeWidth, maxWidth: safeWidth, minHeight: safeHeight, maxHeight: safeHeight)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

#Preview {
    ImageWithGradientAndName(user: FireUser(id: "1", name: "klasd"), distance: "100")
}
