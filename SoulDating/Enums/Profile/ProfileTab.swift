//
//  ProfileTab.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 20.06.24.
//

import Foundation
import SwiftUI

enum ProfileTab: String, CaseIterable, Identifiable {
    case aboutyou, preferences, fotos
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .aboutyou: "About you"
        case .preferences: "Preferences"
        case .fotos: "Photos"
        }
    }
    
    @ViewBuilder
    func view() -> some View {
        switch self {
        case .aboutyou:
            AboutYouView()
        case .preferences:
            PreferencesView()
        case .fotos:
            PhotosView()
        }
    }
}
