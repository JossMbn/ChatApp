//
//  SignUpView.swift
//  ChatApp
//
//  Created by Josselin MABILLON on 16/08/2023.
//

import SwiftUI

struct RegistrationView: View {
    @StateObject private var viewModel = RegistrationViewModel()
    @Environment(\.dismiss) var dismiss
    
    @State private var isSecureField: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                // App Icon
                Image("messenger-app-icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .padding(26)
                
                // Text Fields
                VStack(spacing: 8) {
                    TextField("Enter your email", text: $viewModel.email)
                        .modifier(AuthentificationFieldStyleModifier())
                    
                    TextField("Enter your full name", text: $viewModel.fullName)
                        .modifier(AuthentificationFieldStyleModifier())
                    
                    ZStack(alignment: .trailing) {
                        if isSecureField {
                            TextField("Enter your password", text: $viewModel.password)
                                .modifier(AuthentificationFieldStyleModifier())
                        } else {
                            SecureField("Enter your password", text: $viewModel.password)
                                .modifier(AuthentificationFieldStyleModifier())
                        }
                        Button(
                            action: {
                                isSecureField.toggle()
                            },
                            label: {
                                Image(systemName: isSecureField ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(Color(.systemGray))
                            }
                        )
                        .padding(.horizontal, 8)
                    }
                }
                .padding(.horizontal, 24)
                
                // Error Message return by Firebase
                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(.systemRed))
                        .padding(.top, 15)
                }
                
                // Sign up link
                Button {
                    Task { try await viewModel.createUser() }
                } label: {
                    if viewModel.showLoader {
                        ProgressView()
                    } else {
                        Text("Sign Up")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                }
                .modifier(AuthentificationLoginRegistrationButtonStyleModifier())
                .padding(.vertical)
                .navigationBarBackButtonHidden(true)
            
                Spacer()
                
                // dismiss screen button
                Divider()
                Button {
                    dismiss()
                } label: {
                    HStack {
                        Text("Already have an account ?")
                            .fontWeight(.semibold)
                        Text("Sign in")
                            .fontWeight(.bold)
                    }
                    .font(.footnote)
                }
                .padding(.vertical)
            }
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
