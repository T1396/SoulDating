
//
//  DateFromTimestamp.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 09.06.24.
//

import Foundation

extension DateFormatter {
  static let yyyyMMdd: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
  }()
}

extension JSONDecoder {
  static let firestoreDecoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(DateFormatter.yyyyMMdd)
    return decoder
  }()
}