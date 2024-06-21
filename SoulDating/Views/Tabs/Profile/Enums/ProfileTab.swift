//
//  ProfileTab.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 10.06.24.
//

import Foundation

enum ProfileTab: String, CaseIterable, Identifiable {
    case aboutyou, fotos
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .aboutyou:
            "Über dich"
        case .fotos:
            "Fotos"
        }
    }
}
