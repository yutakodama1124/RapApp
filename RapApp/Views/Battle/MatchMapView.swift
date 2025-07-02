//
//  MatchMapView.swift
//  RapApp
//
//  Created by yuta kodama on 2025/07/02.
//

import SwiftUI
import MapKit

struct MatchMapView: View {
    
    let user: User
    let latitude: Double
    let longitude: Double
    
    var body: some View {
        Map {
            UserAnnotation()
            
            Annotation(user.name, coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude)) {
                Circle()
                    .fill(.cyan)
                    .frame(width:50, height: 50)
            }
            
        }
    }
}

#Preview {
    MatchMapView(
        user: User(
            id: "1124",
            imageURL: "kvara.jpg",
            name: "yuta",
            school: "hgk",
            hobby: "soccer",
            job: "hgk",
            favrapper: "kendrick",
            latitude: 35,
            longitude: 135
        ),
        latitude: 35.0,
        longitude: 135.0
    )
}
