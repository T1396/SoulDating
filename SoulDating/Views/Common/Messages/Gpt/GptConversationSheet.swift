//
//  GptConversationSheet.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 03.07.24.
//

import SwiftUI

struct GptConversationSheet: View {
    // MARK: properties
    @ObservedObject var gptViewModel: GptViewModel
    @State private var showSidebar = false
    @State private var chatOpacity = 0.0

    var body: some View {
        NavigationStack {
            HStack(spacing: 0) {
                if showSidebar {
                    HStack(spacing: 0) {
                        GptConversationSidebar(gptViewModel: gptViewModel)
                        Divider()
                    }
                    .transition(showSidebar ? .move(edge: .leading) : .move(edge: .trailing))

                }

                VStack(spacing: 0) {
                    customToolbar

                    ScrollViewReader { scrollViewProxy in
                        ScrollView {
                            LazyVStack {
                                if let conversation = gptViewModel.conversationManager.getConversation(by: gptViewModel.selectedConversationID ?? "") {
                                    ForEach(conversation.messages) { message in
                                        MessageView(text: message.text, timestamp: message.timestamp, isCurrentUser: message.isFromUser)
                                            .padding(.horizontal, 6)
                                    }
                                    
                                    // displays the streamed chat answer while it is not finished, will be reset than
                                    if !gptViewModel.displayBotMessage.isEmpty {
                                        MessageView(text: gptViewModel.displayBotMessage, timestamp: .now, isCurrentUser: false)
                                            .transition(.opacity)
                                            .animation(.linear, value: gptViewModel.displayBotMessage)
                                    }
                                    Spacer()
                                        .id(3)
                                }
                            }
                            .padding()
                        }
                        .onChange(of: gptViewModel.selectedConversation?.messages, { _, newValue in
                            if newValue != nil {
                                scrollToBottom(scrollViewProxy)
                            }
                        })
                        .onAppear {
                            scrollToBottom(scrollViewProxy) {
                                withAnimation {
                                    chatOpacity = 1.0
                                }
                            }
                        }
                    }

                    HStack {
                        AppTextField(Strings.enterMessage, text: $gptViewModel.gptChatInput)
                        Spacer()
                        Button(action: sendMessage) {
                            Image(systemName: "paperplane.fill")
                                .appButtonStyle(cornerRadius: 20)
                        }
                        .disabled(gptViewModel.sendMessageDisabled)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(.regularMaterial)

                }
            }
        }
    }

    var customToolbar: some View {
        HStack {
            Button(action: toggleSidebar) {
                Image(systemName: "sidebar.left")
                    .font(.title2)
            }
            Spacer()
            Text(gptViewModel.selectedConversation?.startDate.toDateString() ?? "08.07.2024")
                .appFont(size: 16, textWeight: .semibold)
                .frame(maxWidth: .infinity, alignment: .center)
                .lineLimit(1)
            Spacer()
            // For symmetry, button isnt needed
            Button {} label: {
                Image(systemName: "sidebar.left")
                    .font(.title2)
            }
            .opacity(0)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.regularMaterial)
    }

    private func sendMessage() {
        Task {
            await gptViewModel.sendConversationMessage()
        }
    }
    
    private func toggleSidebar() {
        withAnimation {
            showSidebar.toggle()
        }
    }

    private func scrollToBottom(_ scrollViewProxy: ScrollViewProxy, onFinish: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            withAnimation {
                scrollViewProxy.scrollTo(3, anchor: .top)
                onFinish?()
            }
        }
    }

}

#Preview {
    @State var openSheet = false
    return VStack {
        Button("Open Sheet") {
            openSheet = true
        }

        .sheet(isPresented: .constant(true)) {
            GptConversationSheet(gptViewModel: GptViewModel())
        }
    }
}
