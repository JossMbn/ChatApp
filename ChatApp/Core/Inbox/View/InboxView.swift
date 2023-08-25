//
//  InboxView.swift
//  ChatApp
//
//  Created by Josselin MABILLON on 16/08/2023.
//

import SwiftUI

struct InboxView: View {
    @State private var showNewConversation = false
    @StateObject var viewModel = InboxViewModel()
    @State private var selectedUser: User?
    @State private var showChat = false
    
    private var user: User? {
        return viewModel.currentUser
    }
    
    var body: some View {
        NavigationStack {
            /*
             * I do not used scrollview cause there're several issues with navigationDestination.
             * Put everything in a List is a way to workaround this situation.
             */
            List {
                ActiveNowView()
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())
                    .padding(.vertical)
                    .padding(.horizontal, 4)
                
                if viewModel.recentMessages.isEmpty {
                    VStack(alignment: .center, spacing: 5) {
                        Image(systemName: "ellipsis.message")
                            .resizable()
                            .foregroundColor(Color(.systemBlue))
                            .frame(width: 100, height: 100, alignment: .center)
                            .padding()
                        
                        Text("No Conversation")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("You didn't made any conversation yet, please select a username.")
                            .font(.subheadline)
                    }
                    .multilineTextAlignment(.center)
                    .padding(.leading, 35)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())
                } else {
                    ForEach(viewModel.recentMessages) { message in
                        ZStack {
                            NavigationLink(value: message) {
                                EmptyView()
                            }.opacity(0.0)
                            
                            InboxCellView(message: message)
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive, action: {
                                if let chatPartnerId = message.user?.uid {
                                    viewModel.deleteConversation(with: chatPartnerId)
                                }
                            } ) {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
            .onChange(of: selectedUser) { value in
                showChat = value != nil
            }
            .navigationDestination(for: Route.self, destination: { route in
                switch route {
                case .profile(let user):
                    ProfileView(user: user)
                case .chatView(let user):
                    ChatView(user: user)
                        .navigationBarBackButtonHidden(true)
                }
            })
            .navigationDestination(for: Message.self, destination: { message in
                // this NavigationDestination is for enter to a conversation
                if let user = message.user {
                    ChatView(user: user)
                        .navigationBarBackButtonHidden(true)
                }
            })
            .navigationDestination(isPresented: $showChat, destination: {
                // this NavigationDestination is for create a new conversation
                if let user = selectedUser {
                    ChatView(user: user)
                        .navigationBarBackButtonHidden(true)
                }
            })
            .fullScreenCover(isPresented: $showNewConversation, content: {
                NewConversationView(selectedUser: $selectedUser)
            })
            .navigationTitle("ChatApp")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        if let user {
                            NavigationLink(value: Route.profile(user)) {
                                CircularProfileImageView(user: user, imageSize: .small)
                            }
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showNewConversation.toggle()
                        selectedUser = nil
                    } label: {
                        Image(systemName: "square.and.pencil.circle.fill")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .foregroundStyle(.black, Color(.systemGray2))
                    }
                }
            }
        }
    }
}

struct InboxView_Previews: PreviewProvider {
    static var previews: some View {
        InboxView()
    }
}
