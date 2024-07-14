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
    @Binding var contentType: MessageAndProfileView.ContentType

    @EnvironmentObject var userViewModel: UserViewModel
    @StateObject private var gptViewModel = GptViewModel()
    @StateObject private var msgViewModel: MessagesDetailViewModel

    @Environment(\.dismiss) var dismiss

    @State private var sheet: Sheets?
    @State private var loadedImage: Image?
    @State private var showBotSuggestions = false
    @State private var keyboardHeight: CGFloat = 0
    @State private var showReportView = false
    @State private var chatOpacity = 0.0

    // MARK: init
    init(targetUser: FireUser, chatId: String?, contentType: Binding<MessageAndProfileView.ContentType>) {
        self.targetUser = targetUser
        self._msgViewModel = StateObject(wrappedValue: MessagesDetailViewModel(targetUserId: targetUser.id, chatId: chatId))
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
                                Spacer(minLength: 8)
                                ForEach(msgViewModel.messages) { message in
                                    MessageView(text: message.content, timestamp: message.timestamp, isCurrentUser: msgViewModel.isFromCurrentUser(message))
                                        .padding(.horizontal, 6)
                                }
                                Spacer()
                                    .id(3)
                            }
                        }
                        .opacity(chatOpacity)
                        .scrollIndicators(.never)
                        .frame(maxHeight: showBotSuggestions ? .zero : .infinity)
                        .onChange(of: keyboardHeight) { _, _ in
                            scrollToBottom(scrollViewProxy)
                        }
                        .onChange(of: msgViewModel.messages, { _, _ in
                            scrollToBottom(scrollViewProxy)
                        })
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                scrollViewProxy.scrollTo(3, anchor: .bottom)
                                chatOpacity = 1.0
                            }
                        }
                    }

                    if showBotSuggestions {
                        BotSuggestionList(
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
                        .padding()
                        .background(.thinMaterial)
                    }

                    
                    VStack {

                        GptButtonRow(gptViewModel: gptViewModel, showBotSuggestions: $showBotSuggestions, targetUser: targetUser)

                        HStack {
                            AppTextField(Strings.enterMessage, text: $msgViewModel.messageContent)
                            Spacer()
                            Button(action: msgViewModel.sendMessage) {
                                Image(systemName: "paperplane.fill")
                                    .appButtonStyle(cornerRadius: 20)
                            }
                            .disabled(msgViewModel.sendDisabled)
                        }
                    }
                    .padding([.horizontal, .bottom])
                    .padding(.top, 8)
                    .background(.thinMaterial)

                }
                .onAppear(perform: addObservers)
                .onDisappear(perform: removeObservers)
                .toolbar(content: toolbarItems)
            }

        }
        .sheet(item: $sheet, content: { sheet in
            switch sheet {
            case .report:
                ReportSheetView(showSheet: $showReportView, reportedUser: targetUser, onBlocked: {})
            case .gpt:
                GptConversationSheet(gptViewModel: gptViewModel)
            }
        })
        .alert(msgViewModel.alertTitle, isPresented: $msgViewModel.showAlert, actions: {
            Button(Strings.cancel, role: .cancel, action: msgViewModel.dismissAlert)
        }, message: {
            Text(msgViewModel.alertMessage)
        })

    }


    // MARK: toolbar
    @ToolbarContentBuilder
    private func toolbarItems() -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.callout)
            }
        }
        ToolbarItem(placement: .topBarLeading) {
            Button(action: openUserProfile) {
                HStack {
                    RoundedWebImage(imageUrl: targetUser.profileImageUrl, width: 36, height: 36) { image in
                        loadedImage = image
                    }
                    Text(targetUser.name ?? "")
                    Rectangle().fill(.red.opacity(0.00000001))
                }
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
            }
        }
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
            keyboardHeight = 0
        }
    }

    private func scrollToBottom(_ scrollViewProxy: ScrollViewProxy) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.spring()) {
                scrollViewProxy.scrollTo(3, anchor: .bottom)
            }
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
}


#Preview {
    WriteMessageView(
        targetUser: FireUser(id: "kldsa", name: "Kasndjn", profileImageUrl: "kdlsakl", birthDate: .now, gender: .male, onboardingCompleted: true, general: UserGeneral(), location: Location(latitude: 52.20, longitude: 10.01, name: "Hausen", radius: 100), look: Look(), preferences: Preferences(), blockedUsers: [], registrationDate: .now),
        chatId: nil, contentType: .constant(.message))
    .environmentObject(MessagesViewModel())
}
