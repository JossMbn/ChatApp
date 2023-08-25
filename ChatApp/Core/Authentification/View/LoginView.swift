//
//  LoginView.swift
//  ChatApp
//
//  Created by Josselin MABILLON on 16/08/2023.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
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
                        .textInputAutocapitalization(.never)
                    
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
                       
                // Forgot password button
                Button {
                    print("Forgot password")
                } label: {
                    Text("Forgot password")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .padding(.vertical)
                        .padding(.trailing, 20)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                
                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(.systemRed))
                        .transition(.opacity.animation(.linear))
                }

                // Login link
                Button {
                    Task { try await viewModel.login() }
                } label: {
                    if viewModel.showLoader {
                        ProgressView()
                    } else {
                        Text("Login")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                }
                .modifier(AuthentificationLoginRegistrationButtonStyleModifier())
                .padding(.vertical)
                
                Spacer()
                
                // Sign Up link
                Divider()
                NavigationLink {
                    RegistrationView()
                        .navigationBarBackButtonHidden()
                } label: {
                    HStack {
                        Text("Don't have an account ?")
                            .fontWeight(.semibold)
                        Text("Sign up")
                            .fontWeight(.bold)
                    }
                    .font(.footnote)
                }
                .padding(.vertical)

            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
