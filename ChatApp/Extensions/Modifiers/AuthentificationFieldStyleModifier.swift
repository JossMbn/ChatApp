//
//  AuthentificationFieldStyleModifier.swift
//  ChatApp
//
//  Created by Josselin MABILLON on 16/08/2023.
//

import Foundation
import SwiftUI

struct AuthentificationFieldStyleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .padding(12)
            .background(Color(.systemGray5))
            .cornerRadius(10)
            .disableAutocorrection(true)
    }
}
