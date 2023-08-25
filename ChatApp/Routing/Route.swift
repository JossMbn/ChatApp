//
//  Route.swift
//  ChatApp
//
//  Created by Josselin MABILLON on 24/08/2023.
//

import Foundation

enum Route: Hashable {
    case profile(User)
    case chatView(User)
}
