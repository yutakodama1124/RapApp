import Foundation
import Firebase
import FirebaseFirestore
import AVFoundation

class BeatsGateway: ObservableObject {
    
    static let availableBeats = ["battlebeat1", "battlebeat2", "battlebeat3", "battlebeat4"]

    static private var audioPlayer: AVAudioPlayer?
    static private var isCurrentlyPlaying: Bool = false
    static private var currentBeatIndex: Int?

    static func generateRandomBeatIndex() -> Int {
        return Int.random(in: 0..<availableBeats.count)
    }

    static func getBeatFileName(for index: Int) -> String? {
        guard index >= 0 && index < availableBeats.count else { return nil }
        return availableBeats[index]
    }

    static func playBeat(at index: Int) {
        guard let beatFileName = getBeatFileName(for: index) else {
            print("Invalid beat index: \(index)")
            return
        }

        guard let path = Bundle.main.path(forResource: beatFileName, ofType: "mp3") else {
            print("Beat file not found: \(beatFileName)")
            return
        }
        
        let url = URL(fileURLWithPath: path)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
            isCurrentlyPlaying = true
            currentBeatIndex = index
            
            print("Playing beat: \(beatFileName).mp3")
        } catch {
            print("Error playing beat: \(error)")
        }
    }
    
    static func stopBeat() {
        audioPlayer?.stop()
        isCurrentlyPlaying = false
        currentBeatIndex = nil
    }
    
    static func isPlaying() -> Bool {
        return isCurrentlyPlaying && (audioPlayer?.isPlaying ?? false)
    }
}
