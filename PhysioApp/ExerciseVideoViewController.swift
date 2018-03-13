//
//  ExerciseVideoViewController.swift
//  PhysioApp
//
//  Created by Terence Chua on 13/03/2018.
//  Copyright © 2018 Philip Teow. All rights reserved.
//

import UIKit
import AVKit
import FirebaseDatabase
import FirebaseStorage

class ExerciseVideoViewController: UIViewController {
    
    @IBOutlet weak var playVideoButton: UIButton! {
        didSet {
            playVideoButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UITextView!
    
    var selectedVideo : String = ""
    var selectedBodyPart : BodyPart = BodyPart()
    var selectedExercise : Exercise = Exercise()
    
    
    var ref : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        downloadVideosFromStorage()
        
    }
    
    @objc func playButtonTapped() {
        if let path = Bundle.main.path(forResource: selectedVideo, ofType: "mp4") {
            let video = AVPlayer(url: URL(fileURLWithPath: path))
            let videoPlayer = AVPlayerViewController()
            videoPlayer.player = video
            
            present(videoPlayer, animated: true, completion: {
                video.play()
            })
        }
    }
    
    func downloadVideosFromStorage() {
        
        ref.child("bodyParts").child(selectedBodyPart.bodyPart).child("exercises").child(selectedExercise.exerciseID).observe(.value) { (snapshot) in

            if let dict = snapshot.value as? [String:Any],
                let name = dict["name"] as? String,
                let desc = dict["description"] as? String,
                let videoURL = dict["videoUrl"] as? String {
                
                self.nameLabel.text = name
                self.descriptionLabel.text = desc
                let storageRef = Storage.storage().reference(forURL: videoURL)
                storageRef.getData(maxSize: 10 * 1024 * 1024, completion: { (data, error) in
                    if let validError = error {
                        print(validError.localizedDescription)
                    }
                    
                    if let validData = data {
                        print("asd")
                        
                        
                    }
                    
                })
                
            }
        
        }
        
        
            
        
        
//        let storage = Storage.storage()
        
//        storage.reference(forURL: <#T##String#>)
    }
    
    


}
