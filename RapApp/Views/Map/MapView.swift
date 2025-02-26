import SwiftUI
import MapKit
import Firebase
import FirebaseAuth

struct MapView: View {
    private let defaultRegion: MKCoordinateRegion = .init(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    private var locationManager = LocationManager()
    
    @State private var currentUser: User? = User(id: "ss", imageURL: "ss", name: "ss", school: "ss", hobby: "ss", job: "ss", favrapper: "ss")
    
    @State private var currentRegion: MKCoordinateRegion
    @State private var currentLocation: UserLocation? = nil
    
    @State private var nearbyUsers: [User: UserLocation] = [:]

    @State private var isShowAlert: Bool = false
    
    init() {
        currentRegion = defaultRegion
        locationManager.locationManagerDelegate = self
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Map(coordinateRegion: $currentRegion, showsUserLocation: true, userTrackingMode: .none)
                    .edgesIgnoringSafeArea(.all)
                    .onAppear {
                        checkLocationAuthorization()
                        Task {
                            await fetchNearbyUsers() // Start saving and receiving locations
                        }
                        
                    }
                    .alert(isPresented: $isShowAlert) {
                        Alert(title: Text("Location Access Denied"),
                              message: Text("Please enable location access in the Settings app."),
                              dismissButton: .default(Text("OK")))
                    }
                
                ScrollView(.horizontal){
                    
                }
            }
            .navigationTitle("Nearby Users")
        }
    }
    
    
    func fetchNearbyUsers() async {
        let locationGateway = LocationGateway()
        let usergateway = UserGateway()
        
        guard let currentLocation = currentLocation else { return }
        let nearLocations = await locationGateway.getNearLocations(location: currentLocation)
        
    }
    
    func checkLocationAuthorization() {
        let authorizationStatus = CLLocationManager.authorizationStatus() // Use the static method
        switch authorizationStatus {
        case .notDetermined:
            locationManager.locationManager.requestWhenInUseAuthorization() // Access the internal `CLLocationManager` instance
        case .denied, .restricted:
            isShowAlert = true
        case .authorizedWhenInUse, .authorizedAlways:
            break // Location is authorized
        @unknown default:
            isShowAlert = true
        }
    }
}

extension MapView : LocationManagerDelegate {
    func onUpdateLocation(_ location: CLLocation) {
        guard let currentUser = currentUser else { return }
        
        let gateway = LocationGateway()
        
        currentRegion.center = location.coordinate
        
        currentLocation = UserLocation(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            userId: currentUser.id
        )
        
        Task {
            await gateway.saveLocation(location: currentLocation!)
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
