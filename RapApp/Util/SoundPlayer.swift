import UIKit
import AVFoundation

class SoundPlayer: NSObject {
    let music_data = NSDataAsset(name: "battlebeat")!.data
    let audioSession = AVAudioSession.sharedInstance()
    var music_player:AVAudioPlayer!


    func musicPlayer(){
        do {
            music_player = try AVAudioPlayer(data: music_data)
            try audioSession.setCategory(.playback)
            music_player.play()
            print("再生")
        } catch {
            print("エラー発生.音を流せません")
        }

    }

    func stopAllMusic(){
        music_player?.stop()
    }
}

