import SwiftUI
import MapKit
import Firebase
import FirebaseAuth

@MainActor
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let locationManager = CLLocationManager() // Correctly initialized
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
    @State private var fetchTask: Task<Void, Never>? // Task to handle location-receiving
    @State private var alert = false
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var isFollowingUser = true // Automatically follow user's location
    @State private var nextpage = true
    
    var body: some View {
        NavigationView {
            ZStack {
                Map(coordinateRegion: $region, showsUserLocation: true, userTrackingMode: .none)
                    .edgesIgnoringSafeArea(.all)
                    .onChange(of: locationManager.currentLocation) { location in
                        if isFollowingUser, let location = location {
                            region.center = location.coordinate
                        }
                    }
                    .onAppear {
                        checkLocationAuthorization()
                        startSavingAndReceivingLocations() // Start saving and receiving locations
                    }
                    .onDisappear {
                        stopSavingAndReceivingLocations() // Stop saving and receiving locations
                    }
                    .alert(isPresented: $alert) {
                        Alert(title: Text("Location Access Denied"),
                              message: Text("Please enable location access in the Settings app."),
                              dismissButton: .default(Text("OK")))
                    }
                
                ScrollView(.horizontal){
                    
                }
            }
            .navigationTitle("Nearby Users")
            .onAppear {
            }
            }
        }
    func startSavingAndReceivingLocations() {
        // Start saving the user's location every 30 seconds
        saveTask = Task {
            let gateway = LocationGateway()
            while true {
                do {
                    try await Task.sleep(for: .seconds(30)) // Save every 30 seconds
                } catch {
                    print("Save task interrupted: \(error)")
                    break
                }
                
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
                print("Saved location: \(userLocation)")
            }
        }
        
        // Start receiving location info from backend every 30 seconds
        fetchTask = Task {
            let gateway = LocationGateway()
            
            while true {
                do {
                    try await Task.sleep(for: .seconds(30)) // Fetch every 30 seconds
                } catch {
                    print("Fetch task interrupted: \(error)")
                    break
                    
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
                    
                    
                    let locations = await gateway.getNearLocations(location: userLocation)
                    
                    // locations -> userId -> UserGateway (fetchUser) -> User -> add user array
                    
                    
                    print("Fetched locations: \(locations)")
                }
            }
        }
    }
    
    func stopSavingAndReceivingLocations() {
        saveTask?.cancel()
        saveTask = nil
        
        fetchTask?.cancel()
        fetchTask = nil
    }
    
    func checkLocationAuthorization() {
        let authorizationStatus = CLLocationManager.authorizationStatus() // Use the static method
        switch authorizationStatus {
        case .notDetermined:
            locationManager.locationManager.requestWhenInUseAuthorization() // Access the internal `CLLocationManager` instance
        case .denied, .restricted:
            alert = true
        case .authorizedWhenInUse, .authorizedAlways:
            break // Location is authorized
        @unknown default:
            alert = true
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
