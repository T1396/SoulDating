//
//  EditLanguagesView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 01.07.24.
//

import Foundation
import SwiftUI
import UIKit

struct EditLanguagesView: View {
    let fieldName: String
    let initialSelectedLanguages: [String]
    @StateObject private var langVm = LanguagesViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            LanguagesTableView(langVm: langVm)
            Button(action: saveLanguages) {
                Text("Save")
                    .appButtonStyle(fullWidth: true)
            }
            .disabled(langVm.saveDisabled)
            .padding(.horizontal)
        }
        .onAppear {
            let systemLanguageCode = Locale.current.language.languageCode
            if let systemLanguageCode, let isoCode = systemLanguageCode.identifier(.alpha2) {
                langVm.loadLanguageData(for: isoCode)
            }
        }
    }
    
    private func saveLanguages() {
        withAnimation {
            langVm.saveSelectedLanguages(fieldName: fieldName) {
                dismiss()
            }
        }
    }
}

struct LanguagesTableView: UIViewControllerRepresentable {
    @ObservedObject var langVm: LanguagesViewModel

    func makeUIViewController(context: Context) -> UITableViewController {
        let viewController = UITableViewController(style: .plain)
        viewController.tableView.delegate = context.coordinator
        viewController.tableView.dataSource = context.coordinator
        viewController.tableView.sectionIndexColor = .gray
        return viewController
    }

    func updateUIViewController(_ uiViewController: UITableViewController, context: Context) {
        uiViewController.tableView.reloadData()
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(langVm: langVm)
    }

    class Coordinator: NSObject, UITableViewDataSource, UITableViewDelegate {
        @ObservedObject var langVm: LanguagesViewModel

        init(langVm: LanguagesViewModel) {
            self.langVm = langVm
        }

        func numberOfSections(in tableView: UITableView) -> Int {
            langVm.sectionTitles.count
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            let key = langVm.sectionTitles.sorted()[section]
            return langVm.sections[key]?.count ?? 0
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let key = langVm.sectionTitles.sorted()[indexPath.section]
            let language = langVm.sections[key]?[indexPath.row]
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = language?.name
            if let code = language?.code, langVm.selectedLanguages.contains(code) {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            return cell
        }

        func sectionIndexTitles(for tableView: UITableView) -> [String]? {
            langVm.sectionTitles.sorted()
        }

        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            langVm.sectionTitles.sorted()[section]
        }

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let key = langVm.sectionTitles.sorted()[indexPath.section]
            if let language = langVm.sections[key]?[indexPath.row] {
                langVm.toggleLanguage(language.code)
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
}

struct HeaderView: View {
    let title: String
    
    var body: some View {
        Text(title)
            .appFont(size: 18, textWeight: .semibold)
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    EditLanguagesView(fieldName: "djsakl", initialSelectedLanguages: [])
}
