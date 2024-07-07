//
//  SwipeViewSheet.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 14.06.24.
//

import Foundation
import SwiftUI

enum SwipeViewSheet: String, Identifiable, CaseIterable {
    case editRadiusOrLocation, editAgeRange
    
    var id: String { rawValue }
    var title: String {
        switch self {
        case .editRadiusOrLocation:
            "Change the radius in which users appear"
        case .editAgeRange:
            "Change your preferred age span"
        }
    }
}
