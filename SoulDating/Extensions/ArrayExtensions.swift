//
//  ArrayExtensions.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 13.06.24.
//

import Foundation

extension Array<String> {
    func seperated(emptyText: String) -> String {
        if self.isEmpty {
            return emptyText
        } else {
            return self.joined(separator: ", ")
        }
    }
}
