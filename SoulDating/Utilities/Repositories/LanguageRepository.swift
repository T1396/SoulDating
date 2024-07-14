//
//  LanguageRepository.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 14.07.24.
//

import Foundation

class LanguageRepository {
    static let shared = LanguageRepository()
    private var languages: [(code: String, name: String)] = []

    /// loads all languageNames and codes from the specific json file corresponding to the actual user systemLanguage
    func loadLanguageData(for languageCode: String) {
        guard let url = Bundle.main.url(forResource: "languages-\(languageCode)", withExtension: "json") else {
            print("Language JSON file for \(languageCode) not found, falling back to english")
            if languageCode != "en" {
                loadLanguageData(for: "en")
            }
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let languageData = try JSONDecoder().decode(LanguageData.self, from: data)
            if let languageInfo = languageData.main[languageCode]?.localeDisplayNames.languages {
                self.languages = languageInfo.sorted { $0.value.localizedCaseInsensitiveCompare($1.value) == .orderedAscending }
                    .map { (code: $0.key, name: $0.value) }
            } else {
                print("Language code \(languageCode) is not found in the JSON file.")
            }

        } catch {
            print("Error decoding language data for \(languageCode)", error.localizedDescription)
        }
    }

    func getLanguageData() -> [(code: String, name: String)] {
        languages
    }

    // returns the display language name matching the code accepted as parameter or nil if not found
    func languageName(for code: String) -> String? {
        languages.first(where: { $0.code == code })?.name
    }
}
