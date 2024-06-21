//
//  DynamicElementView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 21.06.24.
//

import SwiftUI

struct DynamicUserFieldView: View {
    @EnvironmentObject var profileViewModel: ProfileViewModel
    var item: AboutYouItem

    @ViewBuilder
    var body: some View {
        switch item {
        case .name(let text), .description(let text), .job(let text):
            if let binding = Binding<String>(item: item, profileViewModel: profileViewModel) {
                TextField(item.title, text: binding)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
        case .birthDate(let date):
            if let binding = Binding<Date>(item: item, profileViewModel: profileViewModel) {
                DatePicker(item.title, selection: binding, displayedComponents: .date)
            }
        case .height(let height):
            if let binding = Binding<Int>(item: item, profileViewModel: profileViewModel) {
                TextField(item.title, value: binding, formatter: NumberFormatter())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
        case .interests(let interests):
            EditListView(items: Interests, title: <#T##String#>, subTitle: <#T##String?#>, onSave: <#T##(AnySaveableData) -> Void#>)
            EditableListView(title: item.title, items: Binding(get: {
                interests?.map { $0.title } ?? []
            }, set: { newInterests in
                profileViewModel.updateUserField(item.firebaseFieldName, with: newInterests)
            }))
        // Füge andere spezifische Cases für unterschiedliche Datenformate hinzu
        default:
            Text("Unsupported field type")
        }
    }
}

struct SelectableListView<EnumType: CaseIterable & Hashable & Codable & CustomStringConvertible>: View {
    let title: String
    var fieldName: String
    @ObservedObject var profileViewModel: ProfileViewModel
    @State private var selectedItems: Set<EnumType> = []

    var body: some View {
        VStack(alignment: .leading) {
            Text(title).font(.headline)
            List(Array(EnumType.allCases), id: \.self) { item in
                HStack {
                    Text(item.description)
                    Spacer()
                    Image(systemName: selectedItems.contains(item) ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(selectedItems.contains(item) ? .green : .gray)
                        .onTapGesture {
                            if selectedItems.contains(item) {
                                selectedItems.remove(item)
                            } else {
                                selectedItems.insert(item)
                            }
                        }
                }
            }
            Button("Save", action: {
                let values = Array(selectedItems)
                profileViewModel.updateUserField(fieldName, with: values)
            })
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
        .padding()
        .onAppear {
            loadInitialData()
        }
    }

    private func loadInitialData() {
        if let currentValues = profileViewModel.user[fieldName] {
            
        }
    }
}
