//
//  ChatView.swift
//  ChatApp
//
//  Created by Josselin MABILLON on 20/08/2023.
//

import SwiftUI

struct ChatView: View {
    @StateObject var viewModel: ChatViewModel
    @Environment(\.dismiss) private var dismiss
    
    let user: User
    
    init(user: User) {
        self.user = user
        self._viewModel = StateObject(wrappedValue: ChatViewModel(user: user))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack {
                            CircularProfileImageView(user: user, imageSize: .xLarge)
                            
                            Text(user.fullname)
                                .font(.title3)
                                .bold()
                            Text("messenger")
                                .font(.footnote)
                                .foregroundColor(.gray)
                                .padding(.bottom)
                        }
                        
                        LazyVStack {
                            ForEach(viewModel.messages, id: \.messageId) { message in
                                ChatMessageCell(message: message)
                            }
                        }
                    }
                    .onChange(of: viewModel.messages) {
                        let lastItem = viewModel.messages.last
                        withAnimation {
                            proxy.scrollTo(lastItem?.messageId, anchor: .bottom)
                        }
                    }
                }
                
                ZStack(alignment: .trailing) {
                    TextField("Message...", text: $viewModel.messageText, axis: .vertical)
                        .padding(12)
                        .padding(.trailing, 50)
                        .background(Color("LightDarkGrayColor"))
                        .clipShape(Rectangle())
                        .cornerRadius(10)
                        .font(.subheadline)
                    
                    Button {
                        viewModel.sendMessage()
                        viewModel.messageText = ""
                    } label: {
                        Text("Send")
                            .fontWeight(.semibold)
                    }
                    .padding()
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(user.fullname)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color(.systemPurple))
                            .fontWeight(.semibold)
                    }
                }
            }
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(user: User.MOCK_USER)
    }
}
