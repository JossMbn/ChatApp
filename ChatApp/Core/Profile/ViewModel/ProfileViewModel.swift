//
//  ProfileViewModel.swift
//  ChatApp
//
//  Created by Josselin MABILLON on 16/08/2023.
//

import SwiftUI
import PhotosUI
import Combine

@MainActor
class ProfileViewModel: ObservableObject {
    private var currentUser: User?
    
    @Published var selectedItem: PhotosPickerItem? {
        didSet { Task { try await loadImage() } }
    }
    
    @Published var profileImage: Image?

    init(user: User) {
        self.currentUser = user
    }
    
    func loadImage() async throws {
        guard let item = selectedItem else { return }
        guard let imageData = try await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: imageData) else { return }
        
        uploadProfileImage(uiImage)
        
        self.profileImage = Image(uiImage: uiImage)
    }
    
    func signOut() async throws {
        try await AuthService.shared.signOut()
    }
    
    func deleteAccount() async throws {
        try await AuthService.shared.deleteUser()
    }
    
    func uploadProfileImage(_ image: UIImage) {
        ImageService.uploadProfileImage(image: image) { profileImageUrl in
            UserService.updateUserProfileImageUrl(withUrl: profileImageUrl)
        }
    }
}
