//
//  RegistrationViewModel.swift
//  ChatApp
//
//  Created by Josselin MABILLON on 20/08/2023.
//

import SwiftUI
import Combine

class RegistrationViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var fullName = ""
    @Published var errorMessage: String?
    @Published var showLoader: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupSubscribers()
    }
    
    func createUser() async throws {
        try await AuthService.shared.createUser(withEmail: email, password: password, fullname: fullName)
    }
    
    private func setupSubscribers() {
        AuthService.shared.$registrationErrorMessage.sink { [weak self] error in
            self?.errorMessage = error
        }.store(in: &cancellables)
        
        AuthService.shared.$showLoader.sink { [weak self] isLoading in
            self?.showLoader = isLoading
        }.store(in: &cancellables)
    }
}
