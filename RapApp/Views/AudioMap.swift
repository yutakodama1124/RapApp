import SwiftUI
import MapKit

struct AudioMap: View {
    @StateObject private var audioGateway = AudioGateway()
    @StateObject private var locationManager = LocationManager()
    @State private var selectedAudio: Audio?
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        Map {
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
        .overlay(alignment: .bottom) {
            if let audio = selectedAudio {
                audioPlayerCard(for: audio)
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
        do {
            if let userLocation = locationManager.lastLocation {
                try await audioGateway.fetchAudioLocationsNearby(
                    latitude: userLocation.coordinate.latitude,
                    longitude: userLocation.coordinate.longitude,
                    radiusInKm: 50
                )
            } else {
                try await audioGateway.fetchAllAudioLocations()
            }
        } catch {
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
