//
//  AudioGateway.swift
//  RapApp
//
//  Created by yuta kodama on 2025/10/02.
//

import Foundation
import AVFoundation
import FirebaseStorage
import Firebase
import CoreLocation


class AudioGateway: NSObject, ObservableObject {
    @Published var isRecording = false
    @Published var isPlaying = false
    @Published var recordingTime: TimeInterval = 0
    @Published var audioLocations: [Audio] = []
    
    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer?
    private var recordingTimer: Timer?
    private var audioFileURL: URL?
    
    
    func setupRecorder() async throws {
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.playAndRecord, mode: .default)
        try audioSession.setActive(true)
        
        let permissionGranted = await withCheckedContinuation { continuation in
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                continuation.resume(returning: granted)
            }
        }
        
        guard permissionGranted else {
            throw RecordingError.permissionDenied
        }
    }
    
    
    func startRecording() throws {
        let fileName = UUID().uuidString + ".m4a"
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        audioFileURL = documentsPath.appendingPathComponent(fileName)
        
        
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        guard let url = audioFileURL else { throw RecordingError.invalidURL }
        
        audioRecorder = try AVAudioRecorder(url: url, settings: settings)
        audioRecorder?.record()
        
        isRecording = true
        recordingTime = 0
        
        recordingTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.recordingTime += 0.1
        }
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        recordingTimer?.invalidate()
        isRecording = false
    }
    
    func uploadRecordingToFirebase(opponentId: String) async throws -> String {
        guard let audioFileURL = audioFileURL else {
            throw RecordingError.noRecordingFound
        }
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let audioRef = storageRef.child("match_recordings/\(opponentId).m4a")
        
        let metadata = StorageMetadata()
        metadata.contentType = "audio/m4a"
        
        _ = try await audioRef.putFileAsync(from: audioFileURL, metadata: metadata)
        
        let downloadURL = try await audioRef.downloadURL()
        
        return downloadURL.absoluteString
    }
    
    func playRecording(from url: String) async throws {
        guard let downloadURL = URL(string: url) else {
            throw RecordingError.invalidURL
        }
        
        let (localURL, _) = try await URLSession.shared.download(from: downloadURL)
        
        audioPlayer = try AVAudioPlayer(contentsOf: localURL)
        audioPlayer?.play()
        isPlaying = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (audioPlayer?.duration ?? 0)) {
            self.isPlaying = false
        }
    }
    
    func stopPlaying() {
        audioPlayer?.stop()
        isPlaying = false
    }
    
    func deleteLocalRecording() {
        guard let url = audioFileURL else { return }
        try? FileManager.default.removeItem(at: url)
        audioFileURL = nil
    }
    
    
    
    func fetchAllAudioLocations() async throws {
        let db = Firestore.firestore()
        let snapshot = try await db.collection("audios").getDocuments()
        
        audioLocations = snapshot.documents.compactMap { document in
            try? document.data(as: Audio.self)
        }
    }
    
    func fetchAudioLocationsNearby(latitude: Double, longitude: Double, radiusInKm: Double = 10) async throws {
        try await fetchAllAudioLocations()
        
        audioLocations = audioLocations.filter { audio in
            let distance = calculateDistance(
                lat1: latitude, lon1: longitude,
                lat2: audio.latitude, lon2: audio.longitude
            )
            return distance <= radiusInKm
        }
    }
    
    private func calculateDistance(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> Double {
        let location1 = CLLocation(latitude: lat1, longitude: lon1)
        let location2 = CLLocation(latitude: lat2, longitude: lon2)
        return location1.distance(from: location2) / 1000 // Convert to km
    }
}

enum RecordingError: LocalizedError {
    case permissionDenied
    case invalidURL
    case noRecordingFound
    
    var errorDescription: String? {
        switch self {
        case .permissionDenied:
            return "Microphone permission denied"
        case .invalidURL:
            return "Invalid file URL"
        case .noRecordingFound:
            return "No recording found"
        }
    }
}

