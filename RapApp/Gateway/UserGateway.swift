//
//  UserGateway 2.swift
//  RapApp
//
//  Created by yuta kodama on 2025/01/29.
//


import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
import Foundation
import CoreLocation
import Geohash
import MapKit
import UIKit

class UserGateway {
    private let COLLECTION = Firestore.firestore().collection("users")
    
    func fetchUser(userId: String) async -> User? {
        do {
            let document = try await COLLECTION.document(userId).getDocument()
            if let data = document.data() {
                var user = try Firestore.Decoder().decode(User.self, from: data)
                
                if user.imageURL.isEmpty {
                    user.imageURL = "https://example.com/default-profile.png"
                }
                
                return user
            }
        } catch {
            print("Failed to fetch user: \(error.localizedDescription)")
        }
        return nil
    }
    
    func updateUserInfo(user: User) async -> Bool {
        let db = Firestore.firestore()
        do {
            try await db.collection("users").document(user.id).setData([
                "imageURL": user.imageURL,
                "name": user.name,
                "school": user.school,
                "hobby": user.hobby,
                "job": user.job,
                "favrapper": user.favrapper
            ], merge: true)
            
            print("User information successfully updated: \(user)")
            return true
        } catch {
            print("Error updating user information: \(error.localizedDescription)")
            return false
        }
    }

        
    func uploadImage(user: User, image: UIImage) async -> (success: Bool, url: String?) {
        let storageRef = Storage.storage().reference().child("images/\(user.id).jpg")
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Failed to convert image to data.")
            return (false, nil)
        }
        
        do {
            let _ = try await storageRef.putDataAsync(imageData, metadata: nil)
            let downloadURL = try await storageRef.downloadURL()
            
            var updatedUser = user
            updatedUser.imageURL = downloadURL.absoluteString
            
            let success = await updateUserInfo(user: updatedUser)
            return (success, downloadURL.absoluteString)
            
        } catch {
            print("Failed to upload image: \(error.localizedDescription)")
            return (false, nil)
        }
    }
}
