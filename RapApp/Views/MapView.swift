//
//  Map.swift
//  RapApp
//
//  Created by yuta kodama on 2024/07/13.
//

import SwiftUI
import MapKit

struct MapView: View {
    let manager = CLLocationManager()
    
    @State private var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    
    @State var nextViewPresented = false
    
    var body: some View {
        
        Map(position: $cameraPosition) {
            UserAnnotation()
        }
        .onAppear {
            manager.requestWhenInUseAuthorization()
            manager.requestAlwaysAuthorization()
        }
        .task {
            try? await Task.sleep(for: .seconds(3))
            nextViewPresented = true
        }
        .sheet(isPresented: $nextViewPresented) {
            Detail()
        }
    }
}
#Preview {
    Map()
}

