//
//  GptButtonRow.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 09.07.24.
//

import SwiftUI

struct GptButtonRow: View {
    @ObservedObject var gptViewModel: GptViewModel
    @Binding var showBotSuggestions: Bool
    let targetUser: FireUser

    @State private var showGptSheet = false
    @State private var showGPTInfoPopover = false
    var body: some View {
        HStack {
            InfoPopoverItem(infoText: Strings.gptInfoText, showPopover: $showGPTInfoPopover)

            Button(action: generatePickupLines) {
                Label(Strings.createPickupLines, systemImage: "sparkles.rectangle.stack.fill")
                    .lineLimit(1)
            }
            .itemBackgroundTertiary()

            Button(action: openGptConversationSheet) {
                Label(
                    title: { Text(Strings.askGPT) },
                    icon: { Image("GPT").resizable().frame(width: 12, height: 12) }
                )
            }
            .itemBackgroundTertiary()

            Spacer()

            Spacer()
        }
        .sheet(isPresented: $showGptSheet) {
            GptConversationSheet(gptViewModel: gptViewModel)

        }
    }

    private func openGptConversationSheet() {
        withAnimation {
            showGptSheet = true
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
}

#Preview {
    GptButtonRow(gptViewModel: GptViewModel(), showBotSuggestions: .constant(false), targetUser: FireUser(id: "1"))
}
