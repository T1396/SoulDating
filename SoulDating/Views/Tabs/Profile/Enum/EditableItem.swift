//
//  EditableItem.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 20.06.24.
//

import Foundation

/// defines a protocol that every optionEnum implements to make a generic editListView for the enums 
protocol EditableItem: Identifiable, Codable, Equatable, Hashable, RawRepresentable where RawValue == String {
    var title: String { get }
    var icon: String { get }
}
