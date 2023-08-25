//
//  InboxViewModel.swift
//  ChatApp
//
//  Created by Josselin MABILLON on 20/08/2023.
//

import Foundation
import Combine
import Firebase

class InboxViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var recentMessages = [Message]()
    
    private var cancellables = Set<AnyCancellable>()
    private let service = InboxService()

    init() {
        setupSubscribers()
        service.observeRecentMessages()
    }
    
    func deleteConversation(with chatPartnerId: String) {
        Task { try await service.deleteConversation(with: chatPartnerId) }
    }
    
    private func setupSubscribers() {
        UserService.shared.$currentUser.sink { [weak self] user in
            self?.currentUser = user
        }.store(in: &cancellables)
        
        service.$documentChanges.sink { [weak self] changes in
            self?.loadInitialMessages(fromChanges: changes)
        }.store(in: &cancellables)
    }
    
    private func loadInitialMessages(fromChanges changes: [DocumentChange]) {
        var messages = changes.compactMap({ try? $0.document.data(as: Message.self) })
        
        if changes.count == 1 && changes.first?.type == .removed {
            if let id = messages.first?.chatPartnerId {
                removeDeletedRecentMessages(withUser: id)
            }
        } else {
            for i in 0 ..< messages.count {
                let message = messages[i]
                
                UserService.fetchUser(withUid: message.chatPartnerId) { user in
                    messages[i].user = user
                    
                    if !self.replaceUserMessage(user: user, message: messages[i].messageText) {
                        self.recentMessages.append(messages[i])
                    }
                }
            }
        }
    }
    
    private func replaceUserMessage(user: User, message: String) -> Bool {
        for i in 0 ..< recentMessages.count {
            if recentMessages[i].user == user {
                recentMessages[i].messageText = message
                return true
            }
        }
        return false
    }
    
    private func removeDeletedRecentMessages(withUser id: String) {
        for i in 0 ..< recentMessages.count {
            if recentMessages[i].chatPartnerId == id {
                recentMessages.remove(at: i)
            }
        }
    }
}
