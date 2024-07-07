//
//  RadarSortOption.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 23.06.24.
//

import Foundation

enum RadarSortOption: String, CaseIterable, Identifiable {
    case age, name, distance
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .age: "Age"
        case .name: "Name"
        case .distance: "Distance"
        }
    }
}
