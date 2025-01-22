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


class LocationGateway : LocationGatewayProtocol {
    func saveLocation(location: UserLocation) async {
        let db = Firestore.firestore()
        
        do {
            try db.collection("locations").document().setData(from: location, merge: true)
            print("Location successfully saved")
        } catch {
            print("Error saving location: \(error.localizedDescription)")
        }
    }
    
    func getLocations() async -> [UserLocation] {
        let db = Firestore.firestore()
        do {
            print("Location successfully recieved")
            let json = try await db.collection("locations").getDocuments().documents
            
            print("json: \(json)")
            
            return json.compactMap { try? $0.data(as: UserLocation.self)}
        } catch {
            print("Error fetching location: \(error.localizedDescription)")
        }
        
        return []
    }
}

