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
    
    var selectedVideo : String = ""
    var selectedBodyPart : BodyPart = BodyPart()
//    var selectedExercise : Exercise = Exercise()
    
    
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
        
//        ref.child("bodyParts").child(selectedBodyPart.bodyPart).child("exercises").child(selectedExercise.exerciseID).observe(.value) { (snapshot) in
//
//            if let dict = snapshot.value as? [String:Any],
//                let videoURL = dict["videoUrl"] as? String {
//
//            }
        
//        }
        
        
            
        
        
        let storage = Storage.storage()
        
//        storage.reference(forURL: <#T##String#>)
    }
    
    


}
