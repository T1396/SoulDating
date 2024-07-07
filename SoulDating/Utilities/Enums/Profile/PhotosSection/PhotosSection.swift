//
//  PhotosSection.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 20.06.24.
//

import Foundation

enum PhotosSection: String, Identifiable, CaseIterable {
    case photos
    
    
    var id: String { rawValue }
    
    func items(user: FireUser) -> [PhotosItem] {
        [.images([user.profileImageUrl ?? ""])]
    }
    
    var displayName: String {
        switch self {
        case .photos: "Photos"
        }
    }
}
