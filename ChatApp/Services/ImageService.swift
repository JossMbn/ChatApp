//
//  ImageService.swift
//  ChatApp
//
//  Created by Josselin MABILLON on 25/08/2023.
//

import Foundation
import FirebaseStorage
import SwiftUI

class ImageService {
    
    static func uploadProfileImage(image: UIImage?, completion: @escaping(String) -> Void) {
        guard let imageData = image?.jpegData(compressionQuality: 0.5) else { return }
        
        let filename = NSUUID().uuidString
        let filePath = "/profile_image/\(filename)"
        let ref = Storage.storage().reference(withPath: filePath)
        
        ref.putData(imageData, metadata: nil) { _, error in
            if error != nil {
                print("DEBUG: Failed to upload image with error: \(error?.localizedDescription ?? "")")
                return
            }
            
            ref.downloadURL { imageUrl, error in
                if error != nil {
                    print("DEBUG: Cannot download imageUrl absoluteString with error: \(error?.localizedDescription ?? "")")
                }
                guard let imageUrl = imageUrl?.absoluteString else { return }
                completion(imageUrl)
            }
        }
    }
}
