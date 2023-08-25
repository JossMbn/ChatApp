//
//  Message.swift
//  ChatApp
//
//  Created by Josselin MABILLON on 22/08/2023.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Message: Identifiable, Codable, Hashable {
    @DocumentID var messageId: String?
    let fromId: String
    let toId: String
    var messageText: String
    let timestamp: Timestamp
    
    var user: User?
    
    var id: String {
        return messageId ?? NSUUID().uuidString
    }
    
    var chatPartnerId: String {
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
    }
    
    var isFromCurrentUser: Bool {
        return fromId == Auth.auth().currentUser?.uid
    }
    
    var messageTimestampString: String {
        return self.timestamp.dateValue().timestampString()
    }
}

extension Message {
    static var MOCK_MESSAGE = Message(fromId: "", toId: "", messageText: "This is a test message", timestamp: Timestamp())
}
