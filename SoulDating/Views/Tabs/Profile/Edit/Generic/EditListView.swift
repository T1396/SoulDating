//
//  EditListView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 10.06.24.
//

import SwiftUI

/// generic list view that shows a list of items that implement EditableItem Protocol
struct EditListView<Option: EditableItem>: View {
    // MARK: properties
    var items: [Option] // generic type which is commonly an enum
    @Binding var initialSelected: [Option]?
    let title: String
    let subTitle: String?
    let path: String
    let allowsMultipleSelection: Bool

    @State private var selectedItems: [Option]
    @EnvironmentObject var editVm: EditUserViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text(title)
                    .appFont(size: 32, textWeight: .bold)
                    .padding(.horizontal)

                if let subTitle {
                    Text(subTitle)
                        .appFont(size: 16, textWeight: .thin)
                        .padding(.horizontal)
                }
                ScrollView {
                    LazyVStack {
                        ForEach(items) { itemOption in
                            OptionToggleRow(systemName: itemOption.icon, text: itemOption.title, isSelected: isSelected(itemOption)) {
                                toggleItem(itemOption)
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                HStack {
                    Button(Strings.cancel, action: { dismiss() })
                    Spacer()
                    Button(action: save) {
                        Text(Strings.update)
                            .appButtonStyle()
                    }
                    .disabled(selectedItems == initialSelected)
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
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
            editVm.updateUserField(path, with: selectedItems.map { $0.rawValue })
            initialSelected = selectedItems
        } else {
            if let item = selectedItems.first {
                editVm.updateUserField(path, with: item.rawValue)
                initialSelected = selectedItems
            }
        }
        dismiss()
    }

    // MARK: init
    // initializer for multiple options
    init(items: [Option], initialSelected: Binding<[Option]?>, title: String, subTitle: String?, path: String, allowsMultipleSelection: Bool = false) {
        self.items = items
        self._initialSelected = initialSelected
        self._selectedItems = State(initialValue: initialSelected.wrappedValue ?? [])
        self.title = title
        self.subTitle = subTitle
        self.path = path
        self.allowsMultipleSelection = allowsMultipleSelection
    }

    // initializer for a single option
    init(items: [Option], initialSelected: Binding<Option?>, title: String, subTitle: String?, path: String, allowsMultipleSelection: Bool = false) {
        self.items = items
        let selected = initialSelected.wrappedValue.map { [$0] } ?? []
        self._initialSelected = Binding(get: { selected }, set: { initialSelected.wrappedValue = $0?.first })
        self._selectedItems = State(initialValue: selected)
        self.title = title
        self.subTitle = subTitle
        self.path = path
        self.allowsMultipleSelection = allowsMultipleSelection
    }

    // Initializer single not nilable option
    init(items: [Option], initialSelected: Binding<Option>, title: String, subTitle: String?, path: String, allowsMultipleSelection: Bool = false) {
        self.items = items
        let initialArray = [initialSelected.wrappedValue]
        self._initialSelected = Binding<[Option]?>(
            get: { initialArray },
            set: { newValue in
                if let first = newValue?.first {
                    initialSelected.wrappedValue = first
                }
            }
        )
        self._selectedItems = State(initialValue: initialArray)
        self.title = title
        self.subTitle = subTitle
        self.path = path
        self.allowsMultipleSelection = allowsMultipleSelection
    }
}

#Preview {
    EditListView(items: BodyType.allCases, initialSelected: .constant([.slim]), title: "Update your body type", subTitle: "dklsakl", path: "dksal", allowsMultipleSelection: true)
}
