//
//  LocationManager.swift
//  RapApp
//
//  Created by 浦山秀斗 on 2025/02/26.
//

import Foundation
import CoreLocation

protocol LocationManagerDelegate {
    func onUpdateLocation(_ location: CLLocation)
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    let locationManager = CLLocationManager() // Correctly initialized
    
    var locationManagerDelegate: LocationManagerDelegate? = nil
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        locationManagerDelegate?.onUpdateLocation(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }
}

