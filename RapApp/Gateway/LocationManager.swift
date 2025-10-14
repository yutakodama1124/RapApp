import Foundation
import Firebase
import CoreLocation
import FirebaseAuth

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    @Published var lastLocation: CLLocation?
    private let locationGateway = LocationGateway()

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        requestLocationPermission()
    }
    
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async {
            self.lastLocation = location
            self.updateUserLocation(location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }
    
    private func updateUserLocation(_ location: CLLocation) {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        let user = User(
            id: userId,
            imageURL: "",
            name: "",
            hobby: "",
            favrapper: "",
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            battleCount: 0
            
        )
        
        Task {
            await locationGateway.updateUserLocation(user: user)
        }
    }
}
