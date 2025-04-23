import SwiftUI
import MapKit
import Firebase
import FirebaseAuth

struct MapView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var currentRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var isShowAlert = false
    @State private var nearbyUsers: [User] = []

    private let locationGateway = LocationGateway()
    private let userGateway = UserGateway()

    var body: some View {
        NavigationView {
            ZStack {
                Map(coordinateRegion: $currentRegion, showsUserLocation: true)
                    .edgesIgnoringSafeArea(.all)
                    .onAppear {
                        checkLocationAuthorization()
                    }
                    .onChange(of: locationManager.lastLocation) { newLocation in
                        if let newLocation = newLocation {
                            updateRegion(to: newLocation)
                            Task {
                                await fetchNearbyUsers()
                            }
                        }
                    }
                    .alert(isPresented: $isShowAlert) {
                        Alert(
                            title: Text("Location Access Denied"),
                            message: Text("Please enable location access in the Settings app."),
                            dismissButton: .default(Text("OK"))
                        )
                    }
            }
        }
    }

    private func updateRegion(to location: CLLocation) {
        currentRegion.center = location.coordinate
    }

    private func fetchNearbyUsers() async {
        if let lastLocation = locationManager.lastLocation {
            guard let userId = Auth.auth().currentUser?.uid else { return }
            
            let user = User(
                id: userId,
                imageURL: "",
                name: "",
                school: "",
                hobby: "",
                job: "",
                favrapper: "",
                latitude: lastLocation.coordinate.latitude,
                longitude: lastLocation.coordinate.longitude
            )
            
            nearbyUsers = await userGateway.getNearUser(user: user)
        }
    }

    private func checkLocationAuthorization() {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus == .denied || authorizationStatus == .restricted {
            isShowAlert = true
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
