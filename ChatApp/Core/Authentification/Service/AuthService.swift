//
//  AuthService.swift
//  ChatApp
//
//  Created by Josselin MABILLON on 20/08/2023.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class AuthService {
    
    @Published var userSession: FirebaseAuth.User?
    @Published var loginErrorMessage: String?
    @Published var registrationErrorMessage: String?
    @Published var showLoader: Bool = false
    
    static let shared = AuthService()
    
    init() {
        self.userSession = FirebaseConstants.FirebaseAuth.currentUser
        loadCurrentUserData()
    }
    
    @MainActor
    func login(withEmail email: String, password: String) async throws {
        do {
            self.showLoader = true
            let result = try await FirebaseConstants.FirebaseAuth.signIn(withEmail: email.lowercased(), password: password)
            self.userSession = result.user
            loadCurrentUserData()
            self.showLoader = false
        } catch {
            self.loginErrorMessage = error.localizedDescription
            self.showLoader = false
            print("DEBUG: Failed to sign in user with error: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func createUser(withEmail email: String, password: String, fullname: String) async throws {
        do {
            self.showLoader = true
            let result = try await FirebaseConstants.FirebaseAuth.createUser(withEmail: email.lowercased(), password: password)
            self.userSession = result.user
            try await self.uploadUserData(email: email, fullname: fullname, id: result.user.uid)
            loadCurrentUserData()
            self.showLoader = false
        } catch {
            self.registrationErrorMessage = error.localizedDescription
            self.showLoader = false
            print("DEBUG: Failed to create user with error: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func signOut() async throws {
        do {
            try FirebaseConstants.FirebaseAuth.signOut()
            removeLocalUserData()
        } catch {
            print("DEBUG: Failed to sign out user -> \(userSession?.uid ?? "") with error : \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func deleteUser() async throws {
        guard let uid = FirebaseConstants.FirebaseAuth.currentUser?.uid else { return }
        try await FirestoreConstants.UserCollection.document(uid).delete()
        try await FirebaseConstants.FirebaseAuth.currentUser?.delete()
        removeLocalUserData()
    }
    
    func uploadUserData(email: String, fullname: String, id: String) async throws {
        do {
            let user = User(fullname: fullname, email: email.lowercased(), profileImageUrl: nil)
            guard let encodedUser = try? Firestore.Encoder().encode(user) else { return }
            try await Firestore.firestore().collection("users").document(id).setData(encodedUser)
        } catch {
            self.showLoader = false
            print("DEBUG: Failed to upload user data with error: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func resetUserData() {
        self.userSession = nil
    }
    
    private func loadCurrentUserData() {
        Task { try await UserService.shared.fetchCurrentUser() }
    }
    
    private func removeLocalUserData() {
        self.userSession = nil
        self.loginErrorMessage = nil
        self.registrationErrorMessage = nil
        UserService.shared.currentUser = nil
    }
}
