//
//  UserGatewayProtocol.swift
//  RapApp
//
//  Created by 浦山秀斗 on 2025/01/22.
//

import UIKit

protocol UserGatewayProtocol {
    func fetchUser(userId: String) async -> User?
    func updateUserInfo(from user: User)
    func uploadImage(user: User, image: UIImage) async -> URL?
}
