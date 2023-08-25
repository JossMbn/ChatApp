//
//  ContentViewModel.swift
//  ChatApp
//
//  Created by Josselin MABILLON on 20/08/2023.
//

import Combine
import Firebase

class ContentViewModel: ObservableObject {
    
    @Published var userSession: FirebaseAuth.User?
    @Published var showLoader: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupSubscribers()
    }
    
    private func setupSubscribers() {
        AuthService.shared.$userSession.sink { [weak self] userSessionForAuthService in
            self?.userSession = userSessionForAuthService
        }.store(in: &cancellables)
    }
}
