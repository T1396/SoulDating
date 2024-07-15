//
//  SuggestionListView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 26.06.24.
//

import SwiftUI

/// shows different pick up line suggestions to choose from
struct BotSuggestionList: View {
    // MARK: properties
    var answers: [GptAnswer]
    @Binding var showSuggestions: Bool
    @Binding var isWaitingForAnswers: Bool
    @Binding var errorMessage: String?
    var onSelect: (String) -> Void

    @State private var selectedPickUpLine = ""

    // MARK: computed properties
    var headerText: String {
        isWaitingForAnswers ? Strings.generatingMessages : Strings.chooseLine
    }


    // MARK: body
    var body: some View {

        VStack {
            HStack {
                hideSuggestionsButton

                Spacer()

                Text(Strings.pickupLineTitle)
                    .font(.system(size: 20, weight: .semibold))
                    .frame(maxWidth: .infinity, alignment: .center)

                Spacer()
                // only for symmetry
                hideSuggestionsButton
                    .opacity(0)
            }

            Spacer()
            if isWaitingForAnswers {
                LoadingView(message: headerText)
            } else if let errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red.opacity(0.8))
                    .padding()
            } else {

                ScrollView {
                    LazyVStack {
                        ForEach(answers) { answer in
                            OptionRow(text: answer.message, buttonRole: .cancel) {
                                selectPickupLine(answer: answer)
                            }
                        }
                        .padding(.horizontal)
                    }
                }

            }

            Spacer()

            HStack {
                Button(action: hideSuggestions) {
                    Text(Strings.cancel)
                }

                Spacer()

                Button(action: selectRandomLine) {
                    Text(Strings.chooseRandomLine)
                }
                .disabled(isWaitingForAnswers || answers.isEmpty)
            }
            .padding(.horizontal)
        }
        .frame(maxHeight: .infinity)
    }

    // MARK: subviews
    private var hideSuggestionsButton: some View {
        Button(action: hideSuggestions) {
            Image(systemName: "chevron.down.circle.fill")
                .foregroundColor(.primary)
                .imageScale(.large)
        }
    }

    // MARK: functions
    private func hideSuggestions() {
        withAnimation {
            showSuggestions = false
        }
    }

    // makes callback to insert the chosen line into a textfield e.g.
    private func selectRandomLine() {
        guard !answers.isEmpty else { return }
        selectedPickUpLine = answers.randomElement()?.message ?? answers[0].message
        onSelect(selectedPickUpLine)
    }

    private func selectPickupLine(answer: GptAnswer) {
        selectedPickUpLine = answer.message
        onSelect(selectedPickUpLine)
    }
}

#Preview {
    BotSuggestionList(answers: [], showSuggestions: .constant(true), isWaitingForAnswers: .constant(true), errorMessage: .constant("dsa"), onSelect: { _ in })
}
