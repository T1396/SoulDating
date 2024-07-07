//
//  DoubleFormat.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 14.06.24.
//

import Foundation

extension Double {
    /// Returns a formatted string with a specified number of decimal places.
    func formatted(as style: NumberFormatter.Style = .decimal, maxFractionDigits: Int = 1, locale: Locale = .current) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = style
        formatter.maximumFractionDigits = maxFractionDigits
        formatter.minimumFractionDigits = maxFractionDigits
        formatter.locale = locale
        return formatter.string(from: NSNumber(value: self))
    }
}
