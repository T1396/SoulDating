//
//  ExecuteDelayed.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 17.06.24.
//

import Foundation
import SwiftUI

extension ObservableObject {
    func executeDelayed(delay: Double = 1.0, execution: @escaping() -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            execution()
        }
    }
}

extension View {
    func executeDelayed(delay: Double = 1.0, execution: @escaping() -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            execution()
        }
    }
}
