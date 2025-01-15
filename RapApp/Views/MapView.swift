import SwiftUI
import MapKit
import Foundation
import Firebase
import FirebaseAuth
import Geohash

@MainActor
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var currentLocation: CLLocation? // Stores the user's current location
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocation = location
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }
}

struct MapView: View {
    @ObservedObject var locationManager = LocationManager()
    @State private var saveTask: Task<Void, Never>? // Task to handle location-saving
    @State private var isSavingLocation = false
    @State private var alert = false
    @State var position: MapCameraPosition = .userLocation(fallback: .automatic)
    @State var isshowUserSheet: Bool = false
    
    var body: some View {
        ZStack {
            Map(position: $position)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                Spacer()
                
                Button(action: {
                    isRecievingLocation()
                    toggleSavingLocation()
                }) {
                    Text(isSavingLocation ? "Stop Saving Location" : "Start Saving Location")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
            }
        }
        .onAppear {
            checkLocationAuthorization()
        }
        .onDisappear {
            saveTask?.cancel()
        }
        .alert(isPresented: $alert) {
            Alert(title: Text("Location Access Denied"),
                  message: Text("Please enable location access in the Settings app."),
                  dismissButton: .default(Text("OK")))
        }
    }
    func isRecievingLocation() {
        let gateway = LocationGateway()
        Task {
            let result = await gateway.getLocations()
            print("result ; ", result)
        }
    }
    
    
    func toggleSavingLocation() {
        if isSavingLocation {
            stopSavingLocation()
        } else {
            startSavingLocation()
        }
    }
    
    func startSavingLocation() {
        isSavingLocation = true
        saveTask = Task {
            let gateway = LocationGateway()
            while isSavingLocation {
                try? await Task.sleep(for: .seconds(60))
                
                guard let location = locationManager.currentLocation else {
                    print("Location unavailable")
                    continue
                }
                
                guard let userID = Auth.auth().currentUser?.uid else {
                    print("User not logged in")
                    continue
                }
                
                let userLocation = UserLocation(
                    latitude: location.coordinate.latitude,
                    longitude: location.coordinate.longitude,
                    userId: userID
                )
                await gateway.saveLocation(location: userLocation)
            }
        }
    }
    
    func stopSavingLocation() {
        isSavingLocation = false
        saveTask?.cancel()
        saveTask = nil
    }
    
    func checkLocationAuthorization() {
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse &&
            CLLocationManager.authorizationStatus() != .authorizedAlways {
            alert = true
        }
    }
}

#Preview {
    MapView()
}
