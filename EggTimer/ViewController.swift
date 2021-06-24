//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    let eggTimes = [
        "Soft": 5, // * 60,
        "Medium": 7, // * 60,
        "Hard": 12 // * 60
    ]
    
    var secondsPassed = 0
    var totalTime = 0
    var timer = Timer()
    @IBOutlet weak var titleLabel: UILabel!
    var player: AVAudioPlayer?
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBAction func hardnessSelected(_ sender: UIButton) {
        let hardness = sender.currentTitle!
        totalTime = eggTimes[hardness]!
        titleLabel.text = hardness
        if player != nil && player!.isPlaying {
            player?.stop()
        }
        startTimer(time: totalTime)
    }
    
    func startTimer(time: Int) {
        timer.invalidate()
        secondsPassed = 0
        progressBar.progress = 0.0
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [self] (Timer) in
            secondsPassed += 1
            if secondsPassed < totalTime {
                progressBar.progress = Float(secondsPassed) / Float(totalTime)
            }
            else {
                progressBar.progress = 1.0
                Timer.invalidate()
                titleLabel.text = "Done"
                playSound()
            }
        }
    }

    func playSound() {
        guard let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            guard let player = player else { return }

            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
