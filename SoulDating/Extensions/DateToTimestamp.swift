//
//  DateToTimestamp.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 11.06.24.
//

import Foundation
import Firebase

extension Date {
    func toFirestoreTimestamp() -> Timestamp {
        Timestamp(date: self)
    }
}
