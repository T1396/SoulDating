//
//  UserDetail.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 12.07.24.
//

import Foundation

/// compact details of a user
struct UserDetail: Codable {
    let id: String
    let name: String
    let profileImageUrl: String
}
