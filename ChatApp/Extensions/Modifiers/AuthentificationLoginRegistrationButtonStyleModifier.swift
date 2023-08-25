//
//  AuthentificationLoginRegistrationButtonStyleModifier.swift
//  ChatApp
//
//  Created by Josselin MABILLON on 23/08/2023.
//

import Foundation
import SwiftUI

struct AuthentificationLoginRegistrationButtonStyleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 360, height: 44)
            .foregroundColor(.white)
            .background(Color(.systemBlue))
            .cornerRadius(10)
    }
}
