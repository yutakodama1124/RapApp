import UIKit
import AVFoundation

class SoundPlayer: NSObject {

    let music_data=NSDataAsset(name: "battlebeat")!.data  // 音源の指定
    let audioSession = AVAudioSession.sharedInstance()
    var music_player:AVAudioPlayer!

    // 音楽を再生
    func musicPlayer(){

        do{
            music_player=try AVAudioPlayer(data:music_data)   // 音楽を指定
            try audioSession.setCategory(.playback)
            music_player.play()   // 音楽再生\
            print("再生")
        }catch{
            print("エラー発生.音を流せません")
            Task {
                let user = await AppDelegate.getUser()
            }
        }

    }

    // 音楽を停止
    func stopAllMusic(){
        music_player?.stop()
    }
}

