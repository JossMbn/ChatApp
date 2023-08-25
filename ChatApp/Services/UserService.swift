//
//  UserService.swift
//  ChatApp
//
//  Created by Josselin MABILLON on 20/08/2023.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class UserService {
    
    @Published var currentUser: User?
    
    static let shared = UserService()
        
    @MainActor
    func fetchCurrentUser() async throws {
        guard let uid = FirebaseConstants.FirebaseAuth.currentUser?.uid else { return }
        let snapshot = try await FirestoreConstants.UserCollection.document(uid).getDocument()
        let user = try snapshot.data(as: User.self)
        self.currentUser = user
    }
    
    static func fetchAllUsers(limit: Int? = nil) async throws -> [User] {
        let query = FirestoreConstants.UserCollection
        if let limit { query.limit(to: limit) }
        let snapshot = try await query.getDocuments()
        return snapshot.documents.compactMap({ try? $0.data(as: User.self) })
    }
    
    static func fetchUser(withUid uid: String, completion: @escaping(User) -> Void) {
        FirestoreConstants.UserCollection.document(uid).getDocument { snapshot, _ in
            guard let user = try? snapshot?.data(as: User.self) else { return }
            completion(user)
        }
    }
    
    static func updateUserProfileImageUrl(withUrl url: String) {
        guard let uid = FirebaseConstants.FirebaseAuth.currentUser?.uid else { return }
        
        FirestoreConstants.UserCollection.document(uid).updateData(["profileImageUrl" : url]) { error in
            if error != nil {
                print("DEBUG: cannot update user profile image url with error: \(error?.localizedDescription ?? "")")
                return
            }
        }
    }
}
