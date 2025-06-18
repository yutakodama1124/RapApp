//
//  Match.swift
//  RapApp
//
//  Created by yuta kodama on 2025/06/18.
//

import Foundation
import CoreLocation
import Geohash
import FirebaseFirestore

struct match: Codable, Identifiable{
    @DocumentID var id: String?
    let userAId: String
    let userBId: String
    let latitude: Double
    let longitude: Double
    let accepted: Bool
    
}
