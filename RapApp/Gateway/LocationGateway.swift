//
//  LocationGateway.swift
//  RapApp
//
//  Created by yuta kodama on 2024/10/23.
//

import Foundation
import FirebaseFirestore
import CoreLocation
import MapKit


class LocationGateway: LocationGatewayProtocol {
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
}
