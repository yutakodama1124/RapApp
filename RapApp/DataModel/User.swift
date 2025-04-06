//
//  User.swift
//  RapApp
//
//  Created by yuta kodama on 2024/09/03.
//
import Foundation
import CoreLocation
import Geohash
import FirebaseFirestoreSwift


struct User: Codable, Identifiable, Hashable {
    var id: String
    var imageURL: String
    var name: String
    var school: String
    var hobby: String
    var job: String
    var favrapper: String
    let latitude: Double
    let longitude: Double
    var hash: String {
        Geohash.encode(latitude: latitude, longitude: longitude, length: 7)
    }
    
    static func Empty() -> User {
        return User(id: "", imageURL: "", name: "", school: "", hobby: "", job: "", favrapper: "", latitude: 0, longitude: 0)
    }
}
