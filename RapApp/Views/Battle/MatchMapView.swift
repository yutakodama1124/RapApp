//
//  MatchMapView.swift
//  RapApp
//
//  Created by yuta kodama on 2025/07/02.
//

import SwiftUI
import MapKit

struct MatchMapView: View {
    
    let latitude: Double
    let longitude: Double
    
    var body: some View {
        Map {
            UserAnnotation()
            
            Annotation("Opponent", coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude)) {
                Circle()
                    .fill(.cyan)
                    .frame(width:50, height: 50)
            }
            
        }
        
    }
}
    
    #Preview {
        MatchMapView(
            latitude: 35.0,
            longitude: 135.0
        )
    }

