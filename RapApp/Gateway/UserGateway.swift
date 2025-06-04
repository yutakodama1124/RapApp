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
import FirebaseAuth

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
        do {
            try await COLLECTION.document(user.id!).setData([
                "imageURL": user.imageURL,
                "name": user.name,
                "school": user.school,
                "hobby": user.hobby,
                "job": user.job,
                "favrapper": user.favrapper,
                "latitude": user.latitude,
                "longitude": user.longitude
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
    
    func getUsers() async -> [User] {
        let db = Firestore.firestore()
        do {
            print("Fetching usrs")
            let json = try await db.collection("users").getDocuments().documents
            return json.compactMap { try? $0.data(as: User.self) }
        } catch {
            print("error getting users \(error.localizedDescription)")
        }
        return []
    }
    
    
    func getNearUser(user: User) async -> [User] {
        let users = await getUsers()
        
        let filteredUsers = users.filter {
            return $0.hash == user.hash
        }
        print("fetched users: \(filteredUsers.count)")
        return filteredUsers
    }
    
    func getSelf() async -> User? {
        if let firebaseUser = Auth.auth().currentUser {
            print("Authenticated user: \(firebaseUser.uid)")
            return await fetchUser(userId: firebaseUser.uid)
        } else {
            print("No authenticated user in getSelf")
            return nil
        }
    }
}
