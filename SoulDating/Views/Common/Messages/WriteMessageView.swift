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
    
    @StateObject private var openAIViewModel = ChatMessageViewModel(idProvider: { UUID().uuidString })
    @StateObject private var gptViewModel = GptViewModel()
    @StateObject private var msgViewModel: MessagesViewModel
    
    @EnvironmentObject var userViewModel: UserViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showUserProfile = false
    @State private var loadedImage: Image?
    @State private var showBotSuggestions = false
    @State private var showGPTInfoPopover = false
    @State private var keyboardHeight: CGFloat = 0
    @State private var showReportView = false
    
    // MARK: init
    init(targetUser: User, chatId: String?) {
        self.targetUser = targetUser
        self._msgViewModel = StateObject(wrappedValue: MessagesViewModel(targetUserId: targetUser.id, chatId: chatId))
    }
    
    // MARK: body
    var body: some View {
        ZStack {
            NavigationStack {
                
                if showUserProfile {
                    OtherUserProfileView(showProfile: $showUserProfile, image: $loadedImage, targetUser: targetUser, user: userViewModel.user)
                    
                } else {
                    
                    VStack(spacing: 0) {
                        
                        ScrollViewReader { scrollViewProxy in
                            ScrollView {
                                LazyVStack {
                                    Spacer()
                                    ForEach(msgViewModel.messages) { message in
                                        MessageView(message: message, isCurrentUser: msgViewModel.isFromCurrentUser(message))
                                            .padding(.horizontal, 6)
                                    }
                                    Spacer()
                                        .id(3)
                                }
                            }
                            .scrollIndicators(.never)
                            .frame(maxHeight: showBotSuggestions ? .zero : .infinity)
                            .onChange(of: keyboardHeight) { oldValue, newValue in
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    withAnimation(.spring()) {
                                        scrollViewProxy.scrollTo(3, anchor: .bottom)
                                    }
                                }
                            }
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    scrollViewProxy.scrollTo(3, anchor: .bottom)
                                }
                            }
                        }
                            
                        if showBotSuggestions {
                            VStack(spacing: 8) {
                                SuggestionListView(
                                    answers: gptViewModel.lineOptions,
                                    showSuggestions: $showBotSuggestions,
                                    isWaitingForAnswers: $gptViewModel.isWaitingForBotAnswer,
                                    errorMessage: $gptViewModel.errorMessage
                                ) { chosenLine in
                                    withAnimation {
                                        msgViewModel.messageContent = chosenLine
                                        showBotSuggestions = false
                                    }
                                }
                            }
                        }
                        VStack {
                            HStack {
                                Button(action: generatePickupLines) {
                                    Label("Create Pickup Lines", systemImage: "sparkles.rectangle.stack.fill")
                                }
                                .itemBackgroundTertiary()

                                Button(action: openGptPopover) {
                                    Label(
                                        title: { Text("Ask ChatGPT") },
                                        icon: { Image("GPT").resizable().frame(width: 12, height: 12) }
                                    )
                                }
                                .itemBackgroundTertiary()
                                
                                Spacer()
                                
                                Button(action: { showGPTInfoPopover = true }) {
                                    Image(systemName: "info.circle.fill")
                                        .popover(isPresented: $showGPTInfoPopover, attachmentAnchor: .point(.top), arrowEdge: .top) {
                                            Text("SoulDating lets you interact with OpenAI ChatGPT! You can either let GPT create pickup lines for you or start a conversation to learn more about dating!")
                                                .appFont(size: 12, textWeight: .semibold)
                                                .padding()
                                                .frame(minHeight: 100)
                                                .presentationCompactAdaptation(.popover)
                                        }
                                }
                                Spacer()
                            }
                            
                            
                            HStack {
                                AppTextField("Enter a message", text: $msgViewModel.messageContent)
                                Spacer()
                                Button(action: msgViewModel.sendMessage) {
                                    Text("Send")
                                        .appButtonStyle()
                                }
                            }
                        }
                        .padding([.horizontal, .bottom])
                        .padding(.top, 8)
                        .background(.thinMaterial)

                    }
                    .toolbar(content: toolbarItems)
                    .toolbarRole(.navigationStack)
                }
            }
        }
        .sheet(isPresented: $showReportView) {
            ReportSheetView(showSheet: $showReportView, userId: userViewModel.user.id, reportedUser: targetUser) {
                // todo
            }
        }
        .alert(msgViewModel.alertTitle, isPresented: $msgViewModel.showAlert, actions: {
            Button("Cancel", role: .cancel, action: msgViewModel.dismissAlert)
        }, message: {
            Text(msgViewModel.alertMessage)
        })
        .onAppear(perform: subscribeToKeyboardEvents)
        .onDisappear(perform: unsubscribeFromKeyboardEvents)
    }
    

    // MARK: toolbar
    @ToolbarContentBuilder
    private func toolbarItems() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            BackArrow(showLabel: false, action: navigateBack)
        }
        
        ToolbarItem(placement: .principal) {
            Button(action: openUserProfile) {
                HStack {
                    RoundedAsyncImage(imageUrl: targetUser.profileImageUrl, width: 40, height: 40) { image in
                        loadedImage = image
                    }
                    Text(targetUser.name ?? "")
                    Spacer()
                }
                .foregroundStyle(.primary)
            }                
            .frame(maxWidth: .infinity, alignment: .leading)

        }
        
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: { showReportView = true }) {
                Image(systemName: "ellipsis")
            }
        }
    }
    
    // MARK: functions
    // to minimize scrollView height when keyboard gets opened
    private func subscribeToKeyboardEvents() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                keyboardHeight = keyboardFrame.height
                print(keyboardHeight)
            }
        }
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
            keyboardHeight = 0
        }
    }
    
    private func unsubscribeFromKeyboardEvents() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func openUserProfile() {
        withAnimation(.spring()) {
            showUserProfile.toggle()
        }
    }
    
    private func generatePickupLines() {
        Task {
            withAnimation {
                showBotSuggestions = true
            }
            await gptViewModel.generatePickupLines(user: targetUser) {
                withAnimation(.spring()) {
                    gptViewModel.isWaitingForBotAnswer = false
                }
            }
        }
    }
    
    private func navigateBack() {
        withAnimation {
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    private func openGptPopover() {
        
    }
}


#Preview {
    WriteMessageView(
        targetUser: User(id: "kldsa", name: "Kasndjn", profileImageUrl: "kdlsakl", birthDate: .now, gender: .male, onboardingCompleted: true, general: UserGeneral(), location: LocationPreference(latitude: 52.20, longitude: 10.01, name: "Hausen", radius: 100), look: Look(), preferences: Preferences(), blockedUsers: [], registrationDate: .now),
        chatId: nil)
    .environmentObject(ChatViewModel())
}
