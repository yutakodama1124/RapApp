import SwiftUI
import MapKit

struct AudioMap: View {
    @StateObject private var audioGateway = AudioGateway()
    @StateObject private var locationManager = LocationManager()
    @State private var selectedAudio: Audio?
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var cameraPosition: MapCameraPosition = .automatic
    
    var body: some View {
        ZStack {
            Map(position: $cameraPosition) {
                if let userLocation = locationManager.lastLocation {
                    Annotation("自分", coordinate: userLocation.coordinate) {
                        Circle()
                            .fill(.blue)
                            .frame(width: 20, height: 20)
                    }
                }

                ForEach(audioGateway.audioLocations, id: \.id) { audio in
                    Annotation("", coordinate: CLLocationCoordinate2D(
                        latitude: audio.latitude,
                        longitude: audio.longitude
                    )) {
                        Button {
                            selectedAudio = audio
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(.red)
                                    .frame(width: 30, height: 30)
                                Image(systemName: "music.note")
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
            }
            .mapStyle(.standard)
            
            // Debug overlay
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Debug Info")
                            .font(.caption)
                            .fontWeight(.bold)
                        Text("Audios: \(audioGateway.audioLocations.count)")
                            .font(.caption2)
                        Text("Location: \(locationManager.lastLocation != nil ? "✓" : "✗")")
                            .font(.caption2)
                    }
                    .padding(8)
                    .background(.ultraThinMaterial)
                    .cornerRadius(8)
                    
                    Spacer()
                }
                .padding()
                
                Spacer()
                
                if let audio = selectedAudio {
                    audioPlayerCard(for: audio)
                }
            }
        }
        .task {
            await loadAudioLocations()
        }
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
    }
    
    @ViewBuilder
    private func audioPlayerCard(for audio: Audio) -> some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Audio by \(audio.myId)")
                        .font(.headline)
                }
                
                Spacer()
                
                Button {
                    selectedAudio = nil
                    audioGateway.stopPlaying()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
            
            Button {
                Task {
                    await playAudio(audio)
                }
            } label: {
                HStack {
                    Image(systemName: audioGateway.isPlaying ? "stop.fill" : "play.fill")
                    Text(audioGateway.isPlaying ? "Stop" : "Play")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .disabled(audio.audioRecordingURL == nil)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .padding()
    }
    
    private func loadAudioLocations() async {
        print("🗺️ Starting to load audio locations...")
        
        do {
            if let userLocation = locationManager.lastLocation {
                print("📍 User location found: \(userLocation.coordinate.latitude), \(userLocation.coordinate.longitude)")
                
                try await audioGateway.fetchAudioLocationsNearby(
                    latitude: userLocation.coordinate.latitude,
                    longitude: userLocation.coordinate.longitude,
                    radiusInKm: 50
                )
                
                // Center map on user location
                cameraPosition = .region(MKCoordinateRegion(
                    center: userLocation.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
                ))
            } else {
                print("⚠️ No user location, fetching all audio locations...")
                try await audioGateway.fetchAllAudioLocations()
                
                // If we have audio locations, center on the first one
                if let firstAudio = audioGateway.audioLocations.first {
                    cameraPosition = .region(MKCoordinateRegion(
                        center: CLLocationCoordinate2D(latitude: firstAudio.latitude, longitude: firstAudio.longitude),
                        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
                    ))
                }
            }
            
            print("✅ Loaded \(audioGateway.audioLocations.count) audio locations")
            
            // Log each audio location
            for (index, audio) in audioGateway.audioLocations.enumerated() {
                print("🎵 Audio \(index + 1): ID=\(audio.id ?? "nil"), Lat=\(audio.latitude), Lon=\(audio.longitude)")
            }
            
        } catch {
            print("❌ Error loading audio locations: \(error.localizedDescription)")
            errorMessage = error.localizedDescription
            showError = true
        }
    }
    
    private func playAudio(_ audio: Audio) async {
        guard let urlString = audio.audioRecordingURL else {
            errorMessage = "No audio URL available"
            showError = true
            return
        }
        
        do {
            if audioGateway.isPlaying {
                audioGateway.stopPlaying()
            } else {
                try await audioGateway.playRecording(from: urlString)
            }
        } catch {
            errorMessage = "Failed to play audio: \(error.localizedDescription)"
            showError = true
        }
    }
}

#Preview {
    AudioMap()
}
