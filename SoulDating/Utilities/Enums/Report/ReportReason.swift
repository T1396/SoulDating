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
        case .inappropriatePicture: Strings.inappropriatePicture
        case .harrassmentOrMobbing: Strings.harrassmentOrMobbing
        case .spam: Strings.spam
        case .fakeProfile: Strings.fakeProfile
        case .scam: Strings.scam
        case .offensiveLanguage: Strings.offensiveLanguage
        case .unwantedApproaches: Strings.unwantedApproaches
        case .other: Strings.otherDescription
        }
    }
    
    var description: String {
        switch self {
        case .inappropriatePicture: Strings.inappropriatePictureDescription
        case .harrassmentOrMobbing: Strings.harrassmentOrMobbingDescription
        case .spam: Strings.spamDescription
        case .fakeProfile: Strings.fakeProfileDescription
        case .scam: Strings.scamDescription
        case .offensiveLanguage: Strings.offensiveLanguageDescription
        case .unwantedApproaches: Strings.unwantedApproachesDescription
        case .other: Strings.otherDescription
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
