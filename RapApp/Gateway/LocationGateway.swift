//
//  LocationGateway.swift
//  RapApp
//
//  Created by yuta kodama on 2024/10/23.
//

import Foundation
import FirebaseFirestore
import CoreLocation
import Geohash
import MapKit


class LocationGateway: LocationGatewayProtocol {
    
    private let COLLECTION = Firestore.firestore().collection("users")
    
    func updateUserLocation(user: User) async {
        let geohash = Geohash.encode(latitude: user.latitude, longitude: user.longitude, length: 7)
        let db = Firestore.firestore()
        do {
            try await db.collection("users").document(user.id!).setData([
                "latitude": user.latitude,
                "longitude": user.longitude,
                "hash": geohash
            ], merge: true)
            
            print("User location successfully updated.")
        } catch {
            print("Error updating user location: \(error.localizedDescription)")
        }
    }
}
