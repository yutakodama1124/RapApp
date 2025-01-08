//
//  Location.swift
//  RapApp
//
//  Created by yuta kodama on 2024/10/23.
//

import Foundation
import CoreLocation
import Geohash
import FirebaseFirestoreSwift

struct UserLocation : Codable {
    @DocumentID var id: String?
    let latitude: Double
    let longitude: Double
    let userId: String
    var hash: String {
        Geohash.encode(latitude: latitude, longitude: longitude, length: 10)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.latitude, forKey: .latitude)
        try container.encode(self.longitude, forKey: .longitude)
        try container.encode(self.userId, forKey: .userId)
        try container.encode(self.hash, forKey: .hash)
    }
    
    init(latitude: Double, longitude: Double, userId: String) {
        self.id = UUID().uuidString
        self.latitude = latitude
        self.longitude = longitude
        self.userId = userId
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let idStr = try container.decode(String.self, forKey: .longitude)
        let longtitudeStr = try container.decode(String.self, forKey: .longitude)
        let latitudeStr = try container.decode(String.self, forKey: .latitude)
        
        self.id = idStr
        self.longitude = Double(longtitudeStr) ?? 0
        self.latitude = Double(latitudeStr) ?? 0
        self.userId = try container.decode(String.self, forKey: .userId)
    }
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case latitude
        case longitude
        case userId
        case hash
    }
}
