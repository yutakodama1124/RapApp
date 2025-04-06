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
    
    private let db = Firestore.firestore()
    
    func updateUserLocation(userId: String, latitude: Double, longitude: Double) async -> Bool {
        let db = Firestore.firestore()
        let geohash = Geohash.encode(latitude: latitude, longitude: longitude, length: 7)
        
        do {
            try await db.collection("users").document(userId).setData([
                "latitude": latitude,
                "longitude": longitude,
                "hash": geohash
            ], merge: true)
            
            print("User location successfully updated.")
            return true
        } catch {
            print("Error updating user location: \(error.localizedDescription)")
            return false
        }
    }
    
    func saveLocation(location: UserLocation) async {
        let db = Firestore.firestore()
        do {
            // Query for existing location document with the same userId
            let querySnapshot = try await db.collection("locations")
                .whereField("userId", isEqualTo: location.userId)
                .getDocuments()
            
            if let existingDoc = querySnapshot.documents.first {
                // Update existing document
                try await existingDoc.reference.setData(from: location, merge: true)
                print("Location successfully updated: \(location)")
            } else {
                // Create new document if none exists for this user
                try await db.collection("locations").document().setData(from: location)
                print("New location created: \(location)")
            }
        } catch {
            print("Error saving location: \(error.localizedDescription)")
        }
    }
    
    func getLocations() async -> [UserLocation] {
        let db = Firestore.firestore()
        do {
            print("Fetching locations...")
            let json = try await db.collection("locations").getDocuments().documents
            return json.compactMap { try? $0.data(as: UserLocation.self) }
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
