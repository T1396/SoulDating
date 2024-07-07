//
//  LanguagesViewModel.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 01.07.24.
//

import Foundation
import SwiftUI

/// viewmodel to read all available languages a user can speak by a json file cldr-json (github)
///
class LanguagesViewModel: ObservableObject {
    // MARK: properties
    private let firebaseManager = FirebaseManager.shared
    private let userService: UserService
    private let initialSelectedLanguages: Set<String>
    private var languages: [(code: String, name: String)] = []
    
    @Published var selectedLanguages: Set<String> = []
    @Published var sections: [String: [(code: String, name: String)]] = [:]
    @Published var sectionTitles: [String] = []
    
    // MARK: init
    init(userService: UserService = .shared) {
        self.userService = userService
        let initialSelected = userService.user.general.languages ?? []
        initialSelectedLanguages = Set(initialSelected)
        selectedLanguages = Set(initialSelected)
    }
    
    // MARK: computed properties
    var saveDisabled: Bool {
        selectedLanguages == initialSelectedLanguages
    }
    
    // MARK: functions
    /// save selected languages to firestore and call the completion closure when finished
    func saveSelectedLanguages(fieldName: String, completion: @escaping () -> Void) {
        guard let userId = firebaseManager.userId else { return }
        firebaseManager.database.collection("users")
            .document(userId)
            .updateData([fieldName: Array(selectedLanguages)]) { error in
                if let error {
                    print("Error updating languages", error.localizedDescription)
                } else {
                    self.userService.user.general.languages = Array(self.selectedLanguages)
                    print("successfully updated languages")
                }
                completion()
            }
    }
    
    /// loads all languageNames and codes from the specific json file corresponding to the actual user systemLanguage
    func loadLanguageData(for languageCode: String) {
        guard let url = Bundle.main.url(forResource: "languages-\(languageCode)", withExtension: "json") else {
            print("Language JSON file for \(languageCode) not found, falling back to english")
            loadLanguageData(for: "en")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let languageData = try JSONDecoder().decode(LanguageData.self, from: data)
            if let languageInfo = languageData.main[languageCode]?.localeDisplayNames.languages {
                self.languages = languageInfo.sorted { $0.value.localizedCaseInsensitiveCompare($1.value) == .orderedAscending }
                    .map { (code: $0.key, name: $0.value) }

                DispatchQueue.main.async {
                    self.organizeSections()
                }
            } else {
                print("Language code \(languageCode) is not found in the JSON file.")
            }

        } catch {
            print("Error decoding language data for \(languageCode)", error.localizedDescription)
        }
    }
    
    /// seperates all languages in different sections with their starting letter as key and the languages as value
    private func organizeSections() {
        sections = [:]
        for language in languages {
            let key = String(language.name.prefix(1))
            if sections[key] == nil {
                sections[key] = []
            }
            sections[key]?.append(language)
        }
        sections = sections
        sectionTitles = sections.keys.sorted()
    }
    
    func toggleLanguage(_ code: String) {
        if selectedLanguages.contains(code) {
            selectedLanguages.remove(code)
        } else {
            selectedLanguages.insert(code)
        }
    }
}
