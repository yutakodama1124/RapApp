//
//  UserRepository.swift
//  RapApp
//
//  Created by 浦山秀斗 on 2024/10/10.
//

import FirebaseFirestore
import FirebaseStorage

class UserGateway {
    private let COLLECTION = Firestore.firestore().collection("users")
    
    func fetchUser(userId: String) async -> User? {
        do {
            return try await COLLECTION
                .document(userId)
                .getDocument()
                .data(as: User.self)
        } catch let error as NSError {
            print("Userの取得に失敗しました: \(error.localizedDescription)")
            return nil
        }
    }
    
    func storeUser(from user: User) async {
        try! COLLECTION.document(user.id).setData(from: user)
    }
    
    func uploadImage(user: User, image: UIImage) async -> URL? {
        let storageRef = Storage.storage().reference().child("images/\(user.id).jpg")
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("画像の変換に失敗しました")
            return nil
        }
        
        do {
            let _ = try await storageRef.putDataAsync(imageData, metadata: nil)
        } catch {
            print("画像のアップロードに失敗しました: \(error.localizedDescription)")
            return nil
        }
        
        do {
            return try await storageRef.downloadURL()
        } catch {
            print("URLの取得に失敗しました: \(error.localizedDescription)")
        }
        
        print("不明なエラー")
        return nil
    }
}
