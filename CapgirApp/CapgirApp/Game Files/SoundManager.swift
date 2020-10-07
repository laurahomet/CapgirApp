//
//  SoundManager.swift
//  MatchApp
//
//  Created by Laura Homet Garcia on 16/05/2020.
//  Copyright © 2020 LauraHomet. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager {
    
    var audioPlayer:AVAudioPlayer?
    
    enum SoundEffect {
        case flip
        case match
        case nomatch
        case shuffle
    }
    
    func playSound(effect:SoundEffect) {
        
        var soundFilename = ""
        
        switch effect {
            case .flip:
                soundFilename = "cardflip"
            case .match:
                soundFilename = "dingcorrect"
            case .nomatch:
                soundFilename = "dingwrong"
            case .shuffle:
                soundFilename = "shuffle"
        }
        
        // Get the path to the resource
        let bundlePath = Bundle.main.path(forResource: soundFilename, ofType: ".wav")
        
        // Check that it's not nil. Use guard for sanity check
        guard bundlePath != nil else {
            return
        }
        
        let url = URL(fileURLWithPath: bundlePath!)
        
        do {
            // Create the audio player
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            
            // Play the sound effect
            audioPlayer?.play()
        }
        catch { // If there is an error, catch it and handle it
            print("Couldn't create an audio player")
            return
        }
    }
    
}

