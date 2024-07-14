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
            
            HStack {
                Button(Strings.cancel, action: { dismiss() })
                Spacer()
                Button(action: saveLanguages) {
                    Text(Strings.update)
                        .appButtonStyle()
                }
                .disabled(langVm.saveDisabled)
            }
            .padding()
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

    // connection from tableViewController to SwiftUiView
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

        // returns the number of rows in a given section of the table view
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            let key = langVm.sectionTitles.sorted()[section]
            return langVm.sections[key]?.count ?? 0
        }

        // configures and returns a cell for a given language row in the table view
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

        // returns index titles for the sections
        func sectionIndexTitles(for tableView: UITableView) -> [String]? {
            langVm.sectionTitles.sorted()
        }

        // returns the header title of a given section
        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            langVm.sectionTitles.sorted()[section]
        }

        // handles row selection with the right index menu
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let key = langVm.sectionTitles.sorted()[indexPath.section]
            if let language = langVm.sections[key]?[indexPath.row] {
                langVm.toggleLanguage(language.code)
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
}

#Preview {
    EditLanguagesView(fieldName: "djsakl", initialSelectedLanguages: [])
}
