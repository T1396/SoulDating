//
//  WriteMessageView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 14.06.24.
//

import SwiftUI

struct WriteMessageView: View {
    // MARK: properties
    let targetUser: User
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var msgViewModel: MessagesViewModel
    @State private var showUserProfile = false
    
    
    // MARK: init
    init(targetUser: User, chatId: String?, isPresented: Binding<Bool>) {
        self.targetUser = targetUser
        //self._isPresented = isPresented
        self._msgViewModel = StateObject(wrappedValue: MessagesViewModel(targetUserId: targetUser.id, chatId: chatId))
    }
    
    // MARK: body
    var body: some View {
        ZStack {
            NavigationStack {
                
                if showUserProfile {
                    OtherUserProfileView(showProfile: $showUserProfile, user: targetUser)
                    
                } else {
                    
                    VStack(spacing: 0) {
                        
                        ScrollView {
                            ForEach(msgViewModel.messages) { message in
                                MessageView(message: message, isCurrentUser: msgViewModel.isFromCurrentUser(message))
                                    .padding(.horizontal, 6)
                            }
                        }
                        .scrollIndicators(.never)
                        
                        HStack {
                            TextField("Enter a message", text: $msgViewModel.messageContent)
                                .textFieldStyle(AppTextFieldStyle())
                            Spacer()
                            Button(action: msgViewModel.sendMessage) {
                                Text("Send")
                                    .appButtonStyle()
                            }
                        }
                        .padding()
                        .background(.thinMaterial)
                    }
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            BackArrow(showLabel: false, action: navigateBack)
                        }
                        
                        ToolbarItem(placement: .principal) {
                            HStack {
                                RoundedAsyncImage(imageUrl: targetUser.profileImageUrl, width: 40, height: 40)
                                Text(targetUser.name ?? "")
                                Spacer()
                            }
                            .foregroundStyle(.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(.red.opacity(0.00001)) // ensures somehow that image and picture is clickable in the whole width
                            .onTapGesture {
                                openUserProfile()
                            }
                        }
                        ToolbarItem(placement: .topBarTrailing) {
                            Button(action: navigateBack) {
                                Image(systemName: "ellipsis")
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func openUserProfile() {
        withAnimation(.spring()) {
            showUserProfile.toggle()
        }
    }
    
    private func navigateBack() {
        withAnimation {
            presentationMode.wrappedValue.dismiss()
        }
    }
}


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

struct OtherUserProfileView: View {
    @Binding var showProfile: Bool
    let user: User
    var body: some View {
        ZStack {
            VStack {
                if let url = URL(string: user.profileImageUrl ?? "") {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        Image("sampleimage")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                    }
                } else {
                    Image("sampleimage")
                        .resizable()
                        .scaledToFill()
                        .frame(maxHeight: 600, alignment: .top)
                        .clipped()
                    
                }
                
                Spacer()
                
            }

            Button {
                showProfile.toggle()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.largeTitle)
                    .padding()
                    .background(.white.opacity(0.9), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            }
            .padding()
            .padding(.top, 24)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .ignoresSafeArea()
        .sheet(isPresented: .constant(true), content: {
            ProfileSheet(user: user)
                .transition(.move(edge: .bottom))
                .interactiveDismissDisabled()
                .presentationDragIndicator(.hidden)
                .presentationBackgroundInteraction(.enabled)
                .presentationDetents([.fraction(0.4), .fraction(0.8)])
        })
        
    }
}



#Preview {
    WriteMessageView(
        targetUser: User(id: "kldsa", name: "Kasndjn", profileImageUrl: "kdlsakl", birthDate: .now, gender: .male, wantChilds: true, onboardingCompleted: true, general: UserGeneral(), location: LocationPreference(latitude: 52.20, longitude: 10.01, name: "Hausen", radius: 100), look: Look(), preferences: Preferences(), blockedUsers: [], registrationDate: .now),
        chatId: nil,
        isPresented: .constant(true))
    .environmentObject(ChatViewModel())
}
