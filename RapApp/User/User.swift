//
//  User.swift
//  RapApp
//
//  Created by yuta kodama on 2024/09/03.
//

import Foundation

struct User: Codable {
    var imageURL: URL
    var name: String
    var school: String
    var hobby: String
    var job: String
    
    static func Empty() -> User {
        return User(imageURL: URL(string: "https://louisville.edu/enrollmentmanagement/images/person-icon/image")!, name: "", school: "", hobby: "", job: "")
    }
     
}
