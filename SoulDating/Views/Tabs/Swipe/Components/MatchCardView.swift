//
//  MatchCardView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 07.07.24.
//

import SwiftUI

struct MatchCardView: View {
    // MARK: properties
    @Binding var currentMatch: FireUser?
    var currentUser: FireUser
    var otherUser: FireUser

    // states to detect where to navigate to (message or profile)
    @State private var navigateToUser = false
    @State private var navigateTo: MessageAndProfileView.ContentType = .message
    @State private var otherUserImage: Image?

    var otherUserName: String {
        otherUser.name ?? "Anon"
    }

    var body: some View {
        VStack {
            Image(systemName: "heart.fill")
                .font(.system(size: 80))
                .foregroundStyle(.red.opacity(0.8))
                .padding(.top)

            Text(String(format: Strings.haveMatchWith, otherUserName))
                .appFont(size: 26, textWeight: .bold)
                .multilineTextAlignment(.center)


            HStack(spacing: 20) {
                UserImage(url: currentUser.profileImageUrl, minWidth: 100, minHeight: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                UserImage(url: otherUser.profileImageUrl, minWidth: 100, minHeight: 150, onAppear: { image in
                    otherUserImage = image
                })
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }

            Group {
                Button(action: openProfileView) {
                    Text(String(format: Strings.openProfile, otherUserName))
                        .lineLimit(1)
                        .appButtonStyle(color: .white, type: .secondary, textSize: 14, fullWidth: true)
                }

                Button(action: openMessageView) {
                    Text(String(format: Strings.writeMsgTo, otherUserName))
                        .lineLimit(1)
                        .appButtonStyle(color: .white, type: .secondary, textSize: 14, fullWidth: true)
                }

                Button(action: resetMatch) {
                    Text("OK")
                        .appButtonStyle(color: .red, type: .secondary, textSize: 14, fullWidth: true)
                }

            }
            .padding(.horizontal)

            .fullScreenCover(isPresented: $navigateToUser) {
                let chatId = ChatService.shared.returnChatIdIfExists(for: otherUser.id)
                MessageAndProfileView(contentType: navigateTo, targetUser: otherUser, chatId: chatId, image: $otherUserImage)
            }

        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.matchCard)
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 0)
        .padding()
    }

    // MARK: functions
    private func openMessageView() {
        withAnimation {
            navigateTo = .message
            navigateToUser = true
        }

    }

    private func openProfileView() {
        withAnimation {
            navigateTo = .profile
            navigateToUser = true
        }
    }

    private func resetMatch() {
        withAnimation {
            currentMatch = nil
        }
    }
}

#Preview {
    MatchCardView(currentMatch: .constant(FireUser(id: "2", profileImageUrl: "https://firebasestorage.googleapis.com:443/v0/b/souldating-b6486.appspot.com/o/profileImages%2FbnWnWU1t8NNXDHwhWqFeKUMQfdx1%2F3E3D6A56-10D5-4690-BB39-AB801D122264.jpg?alt=media&token=efdd13d2-50ed-46af-a406-6c8cbf30d53f")), currentUser: FireUser(id: "1", profileImageUrl: "https://firebasestorage.googleapis.com:443/v0/b/souldating-b6486.appspot.com/o/profileImages%2FFW4oOlh92QUyzxUd8reUoYVSBfn2%2F8E55C58C-C011-4A27-B64F-78FDF5921167.jpg?alt=media&token=ad2b148f-3685-40e3-a28a-fbbe7ad2495e"), otherUser: FireUser(id: "2", profileImageUrl: "https://firebasestorage.googleapis.com:443/v0/b/souldating-b6486.appspot.com/o/profileImages%2FbnWnWU1t8NNXDHwhWqFeKUMQfdx1%2F3E3D6A56-10D5-4690-BB39-AB801D122264.jpg?alt=media&token=efdd13d2-50ed-46af-a406-6c8cbf30d53f"))
}
