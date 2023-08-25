//
//  InboxService.swift
//  ChatApp
//
//  Created by Josselin MABILLON on 22/08/2023.
//

import Foundation
import Firebase

class InboxService {
    
    @Published var documentChanges = [DocumentChange]()
        
    func observeRecentMessages() {
        guard let currentUid = FirebaseConstants.FirebaseAuth.currentUser?.uid else { return }
        
        let query = FirestoreConstants.MessagesCollection
            .document(currentUid)
            .collection("recent-messages")
            .order(by: "timestamp", descending: true)
                
        query.addSnapshotListener { snapshot, _ in
            guard let changes = snapshot?.documentChanges.filter({
                $0.type == .added || $0.type == .modified || $0.type == .removed
            }) else { return }
            
            self.documentChanges = changes
        }
    }
    
    func deleteConversation(with chatPartnerId: String) async throws {
        guard let curentUid = FirebaseConstants.FirebaseAuth.currentUser?.uid else { return }
        try await FirestoreConstants.MessagesCollection.document(curentUid).collection("recent-messages").document(chatPartnerId).delete()
    }
}
