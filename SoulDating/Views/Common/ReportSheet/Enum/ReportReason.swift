//
//  ReportReason.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 16.06.24.
//

import Foundation

enum ReportReason: String, CaseIterable, Identifiable {
    case inappropriatePicture, harrassmentOrMobbing, spam, fakeProfile, scam, offensiveLanguage, unwantedApproaches, other
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .inappropriatePicture: "Inappropriate Picture"
        case .harrassmentOrMobbing: "Harassment or Mobbing"
        case .spam: "Spam or Advertising"
        case .fakeProfile: "Fake Profile or Identity"
        case .scam: "Scam or deception"
        case .offensiveLanguage: "Offensive or insulting language"
        case .unwantedApproaches: "Unwanted approaches"
        case .other: "Other reasons"
        }
    }
    
    var description: String {
        switch self {
        case .inappropriatePicture: "The user has posted inappropriate or offensive images."
        case .harrassmentOrMobbing: "The user is engaging in harassment or bullying behavior."
        case .spam: "The user is sending spam or advertising content."
        case .fakeProfile: "The user has a fake profile or is using a false identity."
        case .scam: "The user is involved in fraudulent or deceptive activities."
        case .offensiveLanguage: "The user is using offensive or abusive language."
        case .unwantedApproaches: "The user is making unwanted approaches."
        case .other: "Other reason."
        }
    }
    
    var icon: String {
        switch self {
        case .inappropriatePicture: "photo"
        case .harrassmentOrMobbing: "exclamationmark.bubble"
        case .spam: "megaphone"
        case .fakeProfile: "person.crop.circle.badge.exclamationmark"
        case .scam: "exclamationmark.triangle"
        case .offensiveLanguage: "flame"
        case .unwantedApproaches: "hand.raised"
        case .other: "ellipsis.circle"
        }
    }
}
