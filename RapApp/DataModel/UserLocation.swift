//
//  UserLocation.swift
//  RapApp
//
//  Created by yuta kodama on 2024/10/23.
//

import Foundation
import CoreLocation
import Geohash
import FirebaseFirestore

struct UserLocation: Codable {
    let id: UUID
    let latitude: Double
    let longitude: Double
    let userId: String
    var hash: String {
        Geohash.encode(latitude: latitude, longitude: longitude, length: 7)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id.uuidString, forKey: .id)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
        try container.encode(userId, forKey: .userId)
        try container.encode(hash, forKey: .hash)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
   
        let idStr = try container.decode(String.self, forKey: .id)
        self.id = UUID(uuidString: idStr) ?? UUID()
        self.latitude = try container.decode(Double.self, forKey: .latitude)
        self.longitude = try container.decode(Double.self, forKey: .longitude)
        self.userId = try container.decode(String.self, forKey: .userId)
    }

    init(latitude: Double, longitude: Double, userId: String) {
        self.id = UUID()
        self.latitude = latitude
        self.longitude = longitude
        self.userId = userId
    }

    enum CodingKeys: String, CodingKey {
        case id
        case latitude
        case longitude
        case userId
        case hash
    }
}
