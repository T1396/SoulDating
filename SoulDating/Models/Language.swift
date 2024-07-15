//
//  Language.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 01.07.24.
//

import Foundation

struct LanguageData: Codable {
    let main: [String: LanguageInfo]
}

struct LanguageInfo: Codable {
    let localeDisplayNames: LocaleDisplayNames
}

struct LocaleDisplayNames: Codable {
    let languages: [String: String]
}
