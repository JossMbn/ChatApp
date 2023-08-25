//
//  ChatViewModel.swift
//  ChatApp
//
//  Created by Josselin MABILLON on 22/08/2023.
//

import Foundation

class ChatViewModel: ObservableObject {
    
    @Published var messageText = ""
    @Published var messages = [Message]()
    
    let user: User
    let service: ChatService
    
    init(user: User) {
        self.user = user
        self.service = ChatService(chatPartner: user)
        observeMesages()
    }
    
    func observeMesages() {
        service.observeMessages(of: user) { messages in
            self.messages.append(contentsOf: messages)
        }
    }

    func sendMessage() {
        service.sendMessage(messageText)
    }
}
