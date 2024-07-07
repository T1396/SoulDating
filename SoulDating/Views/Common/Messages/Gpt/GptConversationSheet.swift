//
//  GptConversationSheet.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 03.07.24.
//

import SwiftUI

struct GptConversationSheet: View {
    @ObservedObject var gptViewModel: GptViewModel
    var body: some View {
        VStack {
            Text("Datum")
            ScrollView {
                LazyVStack {
                    ForEach(gptViewModel.conversations, id: \.id) { convo in
                        Text(convo.messages.first?.text ?? "Error")
                    }
                }
            }
            
            HStack {
                AppTextField(Strings.enterMessage, text: $gptViewModel.gptChatInput)
                Spacer()
                Button(action: startNewConversation) {
                    Image(systemName: "paperplane.fill")
                }
                .disabled(gptViewModel.gptChatInput.count < 4)
                .appButtonStyle(cornerRadius: 90)
            }
        }
        .padding()
    }
    
    private func startNewConversation() {
        Task {
            await gptViewModel.startConversation()
        }
    }
}

#Preview {
    GptConversationSheet(gptViewModel: GptViewModel())
}
