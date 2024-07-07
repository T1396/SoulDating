//
//  BotConversationView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 28.06.24.
//

import SwiftUI

struct BotConversationView: View {
    @ObservedObject var gptViewModel: GptViewModel
    var body: some View {
        VStack(alignment: .leading) {
            Text("Get help by ChatGPT!")
                .appFont(size: 20, textWeight: .bold)
            

        }
    }
}

#Preview {
    BotConversationView(gptViewModel: GptViewModel())
}
