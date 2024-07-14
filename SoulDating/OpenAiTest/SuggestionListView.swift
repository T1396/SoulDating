//
//  SuggestionListView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 26.06.24.
//

import SwiftUI

/// shows different pick up line suggestions to choose from
struct SuggestionListView: View {
    var answers: [GptAnswer]
    @Binding var showSuggestions: Bool
    @Binding var isWaitingForAnswers: Bool
    @Binding var errorMessage: String?
    var onSelect: (String) -> Void

    @State private var selectedPickUpLine = ""
    
    var headerText: String {
        isWaitingForAnswers ? "Hold on. Awesome pick up lines are beeing generated for you!" : "Choose your favorite pickup line!"
    }
    
    var body: some View {
        
        
        VStack {
            if isWaitingForAnswers {
                Text(headerText)
                    .appFont(size: 28, textWeight: .bold)
                    .multilineTextAlignment(.center)
                ProgressView()
                    .progressViewStyle(.circular)
                    .scaleEffect(2)
                    .padding()
            } else if let errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red.opacity(0.8))
                    .padding()
            } else {
                Text(headerText)
                    .appFont(size: 28, textWeight: .bold)
                    .multilineTextAlignment(.center)
                
                ScrollView {
                    LazyVStack {
                        ForEach(answers) { answer in
                            Button(action: { selectPickupLine(answer: answer) }, label: {
                                Text(answer.message)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(.accent.opacity(0.13), in: RoundedRectangle(cornerRadius: 12))
                            })
                            .buttonStyle(PressedButtonStyle())
                        }
                        .padding(.horizontal)
                    }
                }
            }
            
            HStack {
                Button(action: { 
                    showSuggestions = false
                }, label: {
                    Text("Cancel")
                })
                .appButtonStyle()
                Spacer()
                Button(action: selectPickupLine) {
                    Text("Save")
                }
                .disabled(selectedPickUpLine.isEmpty)
                .appButtonStyle()

            }
        }
        .frame(maxHeight: .infinity)
    }
    
    // makes callback to insert the chosen line into a textfield e.g.
    private func selectPickupLine() {
        onSelect(selectedPickUpLine)
    }
    
    private func selectPickupLine(answer: GptAnswer) {
        selectedPickUpLine = answer.message
    }
}

#Preview {
    SuggestionListView(answers: [], showSuggestions: .constant(true), isWaitingForAnswers: .constant(true), errorMessage: .constant("dsa"), onSelect: { _ in })
}
