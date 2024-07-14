//
//  FirebaseManager.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 04.06.24.
//

import Firebase
import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class FirebaseManager {
    static let shared = FirebaseManager()

    let auth: Auth
    let database: Firestore
    let storage = Storage.storage()

    private init() {
        auth = Auth.auth()
        database = Firestore.firestore()
    }

    var userId: String? {
        auth.currentUser?.uid
    }
}
