//
//  MaxTextFieldLength.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 14.07.24.
//

import Foundation
import SwiftUI

/// Limits a string binding to an inserted char limit and deletes updates over the limit
extension Binding where Value == String {
    func max(_ limit: Int) -> Self {
        if self.wrappedValue.count > limit {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.prefix(limit))
            }
        }
        return self
    }
}
