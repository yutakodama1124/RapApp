//
//  User.swift
//  RapApp
//
//  Created by yuta kodama on 2024/09/03.
//

import Foundation
import FirebaseFirestore

struct User: Codable, Identifiable {
    var id: String
    var imageURL: String
    var name: String
    var school: String
    var hobby: String
    var job: String
    var favrapper: String
    
    static func Empty() -> User {
        return User(id: "", imageURL: "", name: "", school: "", hobby: "", job: "", favrapper: "")
    }
}
