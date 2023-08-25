//
//  CircularProfileImageViewModel.swift
//  ChatApp
//
//  Created by Josselin MABILLON on 25/08/2023.
//

import Foundation
import Combine
import SwiftUI

class CircularProfileImageViewModel: ObservableObject {
    
    @Published var profileImage: Image?
    
    init(imageUrl: String?) {
        if let imageUrl {
            loadImage(imageUrl: imageUrl)
        }
    }
    
    func loadImage(imageUrl: String) {
        if let imageData = ProfileService().loadProfileImageFromStorage(imageUrl: imageUrl) {
            self.profileImage = Image(uiImage: imageData)
        }
    }
}
