//
//  EditListView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 10.06.24.
//

import SwiftUI

/// generic list view that shows a list of items that implement EditableItem Protocol
struct EditListView<Option: EditableItem>: View {
    var items: [Option]
    var initialSelected: [Option]
    let title: String
    let subTitle: String?
    let path: String
    let allowsMultipleSelection: Bool
    
    @State private var selectedItems: [Option]
    @EnvironmentObject var profileViewModel: ProfileViewModel
    
    init(items: [Option], initialSelected: [Option] = [] ,title: String, subTitle: String?, path: String, allowsMultipleSelection: Bool = false) {
        self.items = items
        self.initialSelected = initialSelected
        self._selectedItems = State(initialValue: initialSelected)
        self.title = title
        self.subTitle = subTitle
        self.path = path
        self.allowsMultipleSelection = allowsMultipleSelection
    }
    
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text(title)
                    .appFont(size: 24, textWeight: .bold)
                
                if let subTitle {
                    Text(subTitle)
                        .appFont(size: 16, textWeight: .thin)
                }
                ScrollView {
                    LazyVStack {
                        ForEach(items) { itemOption in
                            
                            OptionToggleRow(systemName: itemOption.icon, text: itemOption.title, isSelected: isSelected(itemOption)) {
                                toggleItem(itemOption)
                            }
                        }
                    }
                }
                Button(action: save) {
                    Text("Update")
                        .appButtonStyle(fullWidth: true)
                }
                .disabled(selectedItems == initialSelected)
            }
            .padding()
        }
    }
    
    private func toggleItem(_ item: Option) {
        if allowsMultipleSelection {
            if let index = selectedItems.firstIndex(where: { $0.id == item.id }) {
                selectedItems.remove(at: index)
            } else {
                selectedItems.append(item)
            }
        } else {
            selectedItems = [item]
        }
    }
    
    
    private func isSelected(_ item: Option) -> Bool {
        selectedItems.contains(where: { $0.id == item.id })
    }
    
    private func save() {
        if allowsMultipleSelection {
            print("PAth: \(path)")
            print("Selected Items: \(selectedItems)")
            profileViewModel.updateUserField(path, with: selectedItems.map { $0.rawValue })
        } else {
            if let item = selectedItems.first {
                profileViewModel.updateUserField(path, with: item.rawValue)
            }
        }
    }
}

#Preview {
    EditListView(items: BodyType.allCases, initialSelected: [.slim], title: "Update your body type", subTitle: "dklsakl", path: "dksal", allowsMultipleSelection: true)
}
