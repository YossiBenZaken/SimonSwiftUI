//
//  Utility.swift
//  Simon
//
//  Created by Yosef Ben Zaken on 10/10/2022.
//

import AVFoundation

var audioPlayer: AVAudioPlayer?

func playSound(sound: String, type: String) {
    if let path = Bundle.main.path(forResource: sound, ofType: type) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(filePath: path))
            audioPlayer?.play()
        } catch {
            print(error.localizedDescription)
        }
    }
}
