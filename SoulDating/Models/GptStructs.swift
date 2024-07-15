//
//  GptStructs.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 13.07.24.
//

import Foundation

struct GptAnswer: Identifiable, Hashable {
    let id: String
    let message: String
}

struct GptMessage: Identifiable, Codable, Equatable {
    let id: String
    let text: String
    let isFromUser: Bool
    let timestamp: Date
}

struct GptConversation: Identifiable, Codable, Equatable {
    let id: String
    var messages: [GptMessage]
    let startDate: Date
}
