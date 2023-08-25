//
//  ProfileView.swift
//  ChatApp
//
//  Created by Josselin MABILLON on 16/08/2023.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @StateObject private var viewModel: ProfileViewModel
    @State private var showAlert: Bool = false
    let user: User
    
    init(user: User) {
        self.user = user
        self._viewModel = StateObject(wrappedValue: ProfileViewModel(user: user))
        self.showAlert = false
    }
    
    var body: some View {
        VStack {
            // Header
            VStack {
                ZStack(alignment: .bottomTrailing) {
                    PhotosPicker(selection: $viewModel.selectedItem) {
                        if let profileImage = viewModel.profileImage {
                            profileImage
                                .resizable()
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                        } else {
                            CircularProfileImageView(user: user, imageSize: .xLarge)
                        }
                    }
                    Image(systemName: "camera.fill")
                        .resizable()
                        .frame(width: 12, height: 8)
                        .padding(7)
                        .background(.white)
                        .clipShape(Circle())
                        .foregroundColor(.black)
                }
                
                Text(user.fullname)
                    .font(.title2)
                    .fontWeight(.bold)
            }
            
            // List
            List {
                Section {
                    ForEach(SettingsOptionsViewModel.allCases) { option in
                        HStack {
                            Image(systemName: option.iconName)
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(option.iconBackgroundColor)
                            
                            Text(option.title)
                                .font(.subheadline)
                        }
                    }
                }
                
                Section {
                    Button("Log out") {
                        Task { try await viewModel.signOut() }
                    }
                    
                    Button("Delete account") {
                        self.showAlert = true
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Are you sure you want to delete this account ?"),
                            primaryButton: .destructive(Text("Delete")) {
                                Task { try await viewModel.deleteAccount() }
                            },
                            secondaryButton: .cancel() {
                                self.showAlert = false
                            }
                        )
                    }
                }
                .foregroundColor(.red)
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(user: User.MOCK_USER)
    }
}
