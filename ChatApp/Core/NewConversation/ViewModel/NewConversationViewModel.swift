//
//  NewConversationViewModel.swift
//  ChatApp
//
//  Created by Josselin MABILLON on 20/08/2023.
//

import Foundation
import Firebase

@MainActor
class NewConversationViewModel: ObservableObject {
    
    @Published var users = [User]()
    
    init() {
        Task { try await fetchUsers() }
    }
    
    func fetchUsers() async throws {
        guard let currentUid = FirebaseConstants.FirebaseAuth.currentUser?.uid else { return }
        let users = try await UserService.fetchAllUsers()
        self.users = users.filter({ $0.id != currentUid })
    }
}
