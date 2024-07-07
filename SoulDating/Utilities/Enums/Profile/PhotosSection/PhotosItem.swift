//
//  PhotosItem.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 20.06.24.
//

import Foundation

enum PhotosItem: Identifiable {
    case images([String]?)
    
    var id: String { self.title }
    
    var title: String {
        switch self {
        case .images: "Your images"
        }
    }
}
