//
//  LoginViewModel.swift
//  ChatApp
//
//  Created by Josselin MABILLON on 20/08/2023.
//

import SwiftUI
import Combine

class LoginViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage: String?
    @Published var showLoader: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupSubscribers()
    }
    
    func login() async throws {
        try await AuthService.shared.login(withEmail: email, password: password)
    }
    
    private func setupSubscribers() {
        AuthService.shared.$loginErrorMessage.sink { [weak self] error in
            self?.errorMessage = error
        }.store(in: &cancellables)
        
        AuthService.shared.$showLoader.sink { [weak self] isLoading in
            self?.showLoader = isLoading
        }.store(in: &cancellables)
    }
}
