//
//  SortedImage.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 27.06.24.
//

import Foundation

/// struct to save images with a position into firestore, used to move / drop images and sync position changes with firestore
struct SortedImage: Codable, Equatable, Hashable, Identifiable {
    var id: String = UUID().uuidString
    var imageUrl: String
    var position: Int
}

extension SortedImage {
    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String,
              let imageUrl = dictionary["imageUrl"] as? String,
              let position = dictionary["position"] as? Int else {
            return nil
        }
        
        self.id = id
        self.imageUrl = imageUrl
        self.position = position
    }
    
    func toDict(pos: Int) -> [String: Any] {
        let dict: [String: Any] = [
            "id": id,
            "imageUrl": imageUrl,
            "position": pos
        ]
        return dict
    }
}
