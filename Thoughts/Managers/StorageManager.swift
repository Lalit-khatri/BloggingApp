//
//  StorageManager.swift
//  Thoughts
//
//  Created by Lalit kumar on 17/11/22.
//

import Foundation
import FirebaseStorage

final class StorageManager{
    static let shared = StorageManager()
    
    private let container = Storage.storage()
    
    private init(){}
    
    public func uploadUserProfilePicture(
        email: String,
        image: UIImage?,
        completion: @escaping (Bool) -> Void
    ){
        let path = email.replacingOccurrences(of: "@", with: "_").replacingOccurrences(of: ".", with: "_")
        guard let pngData = image?.pngData() else {
            return
        }
        
        container.reference(withPath: "profile_pictures/\(path)/photo.png").putData(pngData, metadata: nil) { metadata, error in
            guard metadata != nil , error == nil else {
                return
            }
            completion(true)
        }
    }
    
    public func downloadUserProfilePicture(
        path: String,
        completion: @escaping (URL?) -> Void
    ){
        container.reference(withPath: path).downloadURL { url, _ in
            completion(url)
        }
        
    }
    
    public func uploadBlogHeaderImage(
        email: String,
        image: UIImage,
        postId: String,
        completion: @escaping (Bool) -> Void
    ){
        let path = email.replacingOccurrences(of: "@", with: "_").replacingOccurrences(of: ".", with: "_")
        guard let pngData = image.pngData() else {
            return
        }
        container.reference(withPath: "post_headers/\(path)/\(postId).png").putData(pngData, metadata: nil) { metadata, error in
            guard metadata != nil , error == nil else {
                return
            }
            completion(true)
        }
    }
    
    public func downloadUrlForPostHeader(
        email: String,
        postId: String,
        completion: @escaping (URL?) -> Void
    ){
        let path = email.replacingOccurrences(of: "@", with: "_").replacingOccurrences(of: ".", with: "_")
        
        container.reference(withPath: "post_headers/\(path)/\(postId).png").downloadURL { url, _ in
            completion(url)
        }
    }
}
