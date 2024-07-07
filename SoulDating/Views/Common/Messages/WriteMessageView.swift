//
//  WriteMessageView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 14.06.24.
//

import SwiftUI

struct WriteMessageView: View {
    enum Sheets: String, Identifiable {
        case report, gpt
        
        var id: String { rawValue }
    }
    // MARK: properties
    let targetUser: FireUser

    @StateObject private var gptViewModel = GptViewModel()
    @StateObject private var msgViewModel: MessagesViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    
    @Binding var contentType: MessageAndProfileView.ContentType
    
    
    @State private var sheet: Sheets?
    @State private var showUserProfile = false
    @State private var loadedImage: Image?
    @State private var showBotSuggestions = false
    @State private var showGPTInfoPopover = false
    @State private var keyboardHeight: CGFloat = 0
    @State private var showReportView = false
    
    // MARK: init
    init(targetUser: FireUser, chatId: String?, contentType: Binding<MessageAndProfileView.ContentType>) {
        self.targetUser = targetUser
        self._msgViewModel = StateObject(wrappedValue: MessagesViewModel(targetUserId: targetUser.id, chatId: chatId))
        self._contentType = contentType
    }
    
    // MARK: body
    var body: some View {
        NavigationStack {
            VStack {

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
                        .onChange(of: keyboardHeight) { _, _ in
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                withAnimation(.spring()) {
                                    scrollViewProxy.scrollTo(3, anchor: .bottom)
                                }
                            }
                        }
                        .onChange(of: msgViewModel.messages, { _, _ in
                            DispatchQueue.main.async {
                                withAnimation {
                                    scrollViewProxy.scrollTo(3, anchor: .bottom)
                                }
                            }
                        })
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
                            InfoPopoverItem(infoText: Strings.gptInfoText, showPopover: $showGPTInfoPopover)

                            Button(action: generatePickupLines) {
                                Label(Strings.createPickupLines, systemImage: "sparkles.rectangle.stack.fill")
                            }
                            .itemBackgroundTertiary()
                            
                            Button(action: openGptPopover) {
                                Label(
                                    title: { Text(Strings.askGPT) },
                                    icon: { Image("GPT").resizable().frame(width: 12, height: 12) }
                                )
                            }
                            .itemBackgroundTertiary()
                            
                            Spacer()

                            Spacer()
                        }
                        
                        
                        HStack {
                            AppTextField(Strings.enterMessage, text: $msgViewModel.messageContent)
                            Spacer()
                            Button(action: msgViewModel.sendMessage) {
                                Image(systemName: "paperplane.fill")
                            }
                            .disabled(msgViewModel.sendDisabled)
                            .appButtonStyle(cornerRadius: 25)
                        }
                    }
                    .padding([.horizontal, .bottom])
                    .padding(.top, 8)
                    .background(.thinMaterial)
                    
                }
                .onAppear(perform: addObservers)
                .onDisappear(perform: removeObservers)
                .toolbar(content: toolbarItems)
                .toolbarRole(.navigationStack)
            }
            
        }
        .sheet(item: $sheet, content: { sheet in
            switch sheet {
            case .report:
                ReportSheetView(showSheet: $showReportView, reportedUser: targetUser) {
                    // todo
                }
            case .gpt:
                GptConversationSheet(gptViewModel: gptViewModel)
            }
        })
        .alert(msgViewModel.alertTitle, isPresented: $msgViewModel.showAlert, actions: {
            Button("Cancel", role: .cancel, action: msgViewModel.dismissAlert)
        }, message: {
            Text(msgViewModel.alertMessage)
        })

    }
    
    
    // MARK: toolbar
    @ToolbarContentBuilder
    private func toolbarItems() -> some ToolbarContent {
        
        ToolbarItem(placement: .topBarLeading) {
            Button(action: openUserProfile) {
                HStack {
                    RoundedWebImage(imageUrl: targetUser.profileImageUrl, width: 40, height: 40) { image in
                        loadedImage = image
                    }
                    Text(targetUser.name ?? "")
                    Rectangle().fill(.clear)
                }
                .background(.red.opacity(0.00000001))
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: {
                sheet = .report
            }, label: {
                Image(systemName: "ellipsis")
            })
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

    private func addObservers() {
        subscribeToKeyboardEvents()
        msgViewModel.startListeningForMessages()
    }

    private func removeObservers() {
        msgViewModel.stopListeningForMessages()
        unsubscribeFromKeyboardEvents()
    }

    private func unsubscribeFromKeyboardEvents() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func openUserProfile() {
        withAnimation {
            contentType = .profile
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
    
    private func openGptPopover() {
        withAnimation {
            sheet = .gpt
        }
    }
}


#Preview {
    WriteMessageView(
        targetUser: FireUser(id: "kldsa", name: "Kasndjn", profileImageUrl: "kdlsakl", birthDate: .now, gender: .male, onboardingCompleted: true, general: UserGeneral(), location: LocationPreference(latitude: 52.20, longitude: 10.01, name: "Hausen", radius: 100), look: Look(), preferences: Preferences(), blockedUsers: [], registrationDate: .now),
        chatId: nil, contentType: .constant(.message))
    .environmentObject(ChatViewModel())
}
