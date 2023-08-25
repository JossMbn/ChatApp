//
//  NewConversationView.swift
//  ChatApp
//
//  Created by Josselin MABILLON on 16/08/2023.
//

import SwiftUI

struct NewConversationView: View {
    @StateObject private var viewModel = NewConversationViewModel()
    
    @State private var searchText = ""
    @Environment(\.dismiss) var dismiss
    @Binding var selectedUser: User?
    
    var searchResults: [User] {
        if searchText.isEmpty {
            return viewModel.users
        } else {
            return viewModel.users.filter {
                $0.fullname.contains(searchText.lowercased()) ||
                $0.fullname.contains(searchText.uppercased())
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                Text("CONTACTS")
                    .foregroundColor(.gray)
                    .font(.footnote)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.top)
                
                ForEach(searchResults) { user in
                    VStack {
                        HStack() {
                            CircularProfileImageView(user: user, imageSize: .small)
                            Text(user.fullname)
                                .fontWeight(.bold)
                                .lineLimit(1)
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        Divider()
                            .padding(.leading, 20)
                    }
                    .onTapGesture {
                        selectedUser = user
                        dismiss()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("New Conversation")
            .searchable(
                text: $searchText,
                placement: .navigationBarDrawer(displayMode: .automatic),
                prompt: "Search"
            )
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading, content: {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(Color(.systemBlue))
                })
            }
        }
    }
}

struct NewConversationView_Previews: PreviewProvider {
    static var previews: some View {
        NewConversationView(selectedUser: .constant(User.MOCK_USER))
    }
}
