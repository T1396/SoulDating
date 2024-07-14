//
//  ProfileTab.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 20.06.24.
//

import Foundation
import SwiftUI

enum ProfileTab: String, TabEnum {
    case aboutyou, preferences, fotos
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .aboutyou: Strings.aboutYouTitle
        case .preferences: Strings.preferencesTitle
        case .fotos: Strings.photosTitle
        }
    }
    
    @ViewBuilder
    func view(profileVm: ImagesViewModel) -> some View {
        switch self {
        case .aboutyou:
            AboutYouView()
        case .preferences:
            PreferencesView()
        case .fotos:
            PhotosView(imagesVm: profileVm)
        }
    }
}
