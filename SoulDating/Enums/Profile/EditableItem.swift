//
//  EditableItem.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 20.06.24.
//

import Foundation

/// defines a protocol that every user attribut implements, to make them generic for loops or as parameters
protocol EditableItem: Identifiable, Codable, Hashable, RawRepresentable where RawValue == String {
    var title: String { get }
    var icon: String { get }
}
