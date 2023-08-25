//
//  Constants.swift
//  ChatApp
//
//  Created by Josselin MABILLON on 22/08/2023.
//

import Foundation
import Firebase
import FirebaseStorage

struct FirestoreConstants {
    static let UserCollection = Firestore.firestore().collection("users")
    static let MessagesCollection = Firestore.firestore().collection("messages")
}

struct FirebaseConstants {
    static let FirebaseAuth = Auth.auth()
}
