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
            try await db.collection("users").document(user.id).setData([
                "latitude": user.latitude,
                "longitude": user.longitude,
                "hash": geohash
            ], merge: true)
            
            print("User location successfully updated.")
        } catch {
            print("Error updating user location: \(error.localizedDescription)")
        }
    }

    func updateUserInfo(user: User) async -> Bool {
        let db = Firestore.firestore()
        do {
            try await db.collection("users").document(user.id).setData([
                "imageURL": user.imageURL,
                "name": user.name,
                "school": user.school,
                "hobby": user.hobby,
                "job": user.job,
                "favrapper": user.favrapper
            ], merge: true)
            
            print("User information successfully updated: \(user)")
            return true
        } catch {
            print("Error updating user information: \(error.localizedDescription)")
            return false
        }
    }
    
    func getLocations() async -> [User] {
        let db = Firestore.firestore()
        do {
            print("Fetching locations...")
            let json = try await db.collection("locations").getDocuments().documents
            return json.compactMap { try? $0.data(as: User.self) }
        } catch {
            print("Error fetching locations: \(error.localizedDescription)")
        }
        return []
    }
    
    func getNearLocations(location: UserLocation) async -> [UserLocation] {
        let locations = await getLocations()
        
        print("📡 Fetching locations... Total: \(locations.count)")
        
        let filteredLocations = locations.filter {
            print("Comparing hash: \(location.hash) == \($0.hash)")
            return $0.hash == location.hash
        }
        
        
        
        print("Nearby Users Found: \(filteredLocations.count)")
        return filteredLocations
    }
}
