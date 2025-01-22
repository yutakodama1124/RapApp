//
//  UserDummyGateway.swift
//  RapApp
//
//  Created by 浦山秀斗 on 2025/01/22.
//

import Foundation
import UIKit

class UserGatewayDummy: UserGatewayProtocol {
    private var users: [String: User]

    init() {
        // 静的な初期データ
        self.users = [
            "user1": User(
                id: "user1",
                imageURL: URL(string: "https://example.com/images/user1.jpg")!,
                name: "Alice Smith",
                school: "Tokyo University",
                hobby: "Photography",
                job: "Software Engineer"
            ),
            "user2": User(
                id: "user2",
                imageURL: URL(string: "https://example.com/images/user2.jpg")!,
                name: "Bob Johnson",
                school: "Kyoto University",
                hobby: "Cycling",
                job: "Data Scientist"
            ),
            "user3": User(
                id: "user3",
                imageURL: URL(string: "https://example.com/images/user3.jpg")!,
                name: "Charlie Brown",
                school: "Osaka University",
                hobby: "Cooking",
                job: "Product Manager"
            )
        ]
    }

    // ユーザー情報を取得
    func fetchUser(userId: String) async -> User? {
        return users[userId]
    }

    // ユーザー情報を保存または更新
    func storeUser(from user: User) {
        users[user.id] = user
    }

    // 画像をアップロード（ダミーURLを生成）
    func uploadImage(user: User, image: UIImage) async -> URL? {
        let imageId = UUID().uuidString
        return URL(string: "https://example.com/images/\(imageId).jpg")
    }
}
