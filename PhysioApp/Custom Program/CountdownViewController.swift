//
//  CountdownViewController.swift
//  PhysioApp
//
//  Created by Philip Teow on 15/03/2018.
//  Copyright © 2018 Philip Teow. All rights reserved.
//

import UIKit
import CountdownLabel
import AVFoundation

class CountdownViewController: UIViewController, CountdownLabelDelegate {
    
    @IBOutlet weak var pauseButton: UIButton! {
        didSet {
            pauseButton.addTarget(self, action: #selector(pauseButtonTapped), for: .touchUpInside)
            pauseButton.layer.cornerRadius = 10
            pauseButton.layer.borderWidth = 0
        }
    }
    @IBOutlet weak var doneButton: UIButton! {
        didSet {
            doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
            doneButton.layer.cornerRadius = 10
            doneButton.layer.borderWidth = 0
        }
    }
    
    
    var minute : Int = 0
    var second : Int = 0
    var countdownLabel : CountdownLabel = CountdownLabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "Gradient Background")
        backgroundImage.alpha = 0.5
        self.view.insertSubview(backgroundImage, at: 0)
        
        createCountdownLabel()
    }
    
    func createCountdownLabel() {
        let totalTime = minute * 60 + second
        print(view.frame.width)
        print(view.frame.height)
        
        let frame = CGRect(x: view.frame.width/2 - 150, y: view.frame.height/2 - 200, width: 300, height: 300)
        //  let frame = CGRect(x: 200, y: 300, width: 100, height: 100)
        
        countdownLabel = CountdownLabel(frame: frame, minutes: TimeInterval(totalTime))
        countdownLabel.animationType = .Evaporate
        countdownLabel.countdownDelegate = self
        countdownLabel.font = UIFont(name:"Helvetica Neue", size:CGFloat(75))
        countdownLabel.textColor = UIColor.white
        
        view.addSubview(countdownLabel)
        countdownLabel.start()
    }
    
    @objc func pauseButtonTapped() {
        if countdownLabel.isPaused {
            // timer start
            countdownLabel.start()
            pauseButton.setTitle("Pause", for: .normal)
        } else {
            // timer pause
            countdownLabel.pause()
            pauseButton.setTitle("Resume", for: .normal)
        }
    }
    
    @objc func doneButtonTapped() {
        
        countdownLabel.cancel()
        
        dismiss(animated: true, completion: nil)
    }
    
    
    func countdownFinished() {

        
        // create a sound ID, in this case its the tweet sound.
        let systemSoundID: SystemSoundID = 1005
        
        // to play sound
        AudioServicesPlaySystemSound (systemSoundID)
        
        
    }
    
    
    
}
