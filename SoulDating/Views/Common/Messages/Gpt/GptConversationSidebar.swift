//
//  GptConversationSidebar.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 09.07.24.
//

import SwiftUI

/// displays a side bar with all gpt conversations in a scrollView
struct GptConversationSidebar: View {
    // MARK: properties
    @ObservedObject var gptViewModel: GptViewModel

    var body: some View {
        VStack {

            Button {
                gptViewModel.createNewConversation()
            } label: {
                Label("New", systemImage: "plus.message.fill")
                    .font(.callout)
                    .frame(maxWidth: .infinity)
                    .itemBackgroundStyle()
            }
            Spacer()
            ScrollView {
                LazyVStack {
                    ForEach(gptViewModel.gptConversations) { convo in
                        Button {
                            gptViewModel.changeConversation(convo.id)
                        } label: {
                            VStack(spacing: 4) {
                                Text(convo.messages.first?.text ?? "Empty Chat")
                                    .lineLimit(1)
                                Text(convo.startDate.toDateString())
                                    .font(.caption)
                            }
                            .frame(maxWidth: .infinity)

                            .itemBackgroundStyleAlt(convo.id == gptViewModel.selectedConversationID ? .secondaryAccent : .gray.opacity(0.2), padding: 8, cornerRadius: 12)
                        }
                    }
                }
            }

        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .frame(maxWidth: 160)
        .background(.ultraThickMaterial)
    }
}

#Preview {
    GptConversationSidebar(gptViewModel: .init())
}
