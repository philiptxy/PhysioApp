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
import FirebaseAuth

class ExerciseVideoViewController: UIViewController {
    
    
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    
    @IBAction func favoriteButtonTapped(_ sender: UIBarButtonItem) {
        
        if let user = Auth.auth().currentUser {
            let userID = user.uid
            
            let favoritePost : [String : Any] = [selectedExercise.exerciseID : true]
            ref.child("users").child(userID).child("favorites").child(selectedBodyPart.bodyPart).setValue(favoritePost)
        }
        
        if favoriteChecker == false {
            let filledStarImage = UIImage(named: "Filled Star")
            sender.setBackgroundImage(filledStarImage, for: .normal, barMetrics: .default)
            sender.tintColor = UIColor.black
            favoriteChecker = true
        } else {
            let emptyStarImage = UIImage(named: "Empty Star")
            sender.setBackgroundImage(emptyStarImage, for: .normal, barMetrics: .default)
            sender.tintColor = UIColor.black
            favoriteChecker = false
        }
    }
    
    @IBOutlet weak var playVideoButton: UIButton! {
        didSet {
            playVideoButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var watchVideoLabel: UILabel! {
        didSet {
            let tap = UITapGestureRecognizer(target: self, action: #selector(playButtonTapped))
            watchVideoLabel.addGestureRecognizer(tap)
            watchVideoLabel.isUserInteractionEnabled = true
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UITextView!
    
    var selectedBodyPart : BodyPart = BodyPart()
    var selectedExercise : Exercise = Exercise()
    var downloadURL : URL?
    
    var ref : DatabaseReference!
    
    var favoriteChecker : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        downloadVideosFromStorage()
        
        if let user = Auth.auth().currentUser {
            let userID = user.uid
            ref.child("users").child(userID).child("favorites").child(selectedBodyPart.bodyPart).observe(.childAdded, with: { (snapshot) in
                
                if snapshot.key == self.selectedExercise.exerciseID && snapshot.value != nil {
                    let filledStarImage = UIImage(named: "Filled Star")
                    self.favoriteButton.setBackgroundImage(filledStarImage, for: .normal, barMetrics: .default)
                    self.favoriteButton.tintColor = UIColor.black
                    self.favoriteChecker = true
                }
            })
        }
        
    }
    
    @objc func playButtonTapped() {
        guard let url = downloadURL else {return}
        let video = AVPlayer(url: url)
        let videoPlayer = AVPlayerViewController()
        videoPlayer.player = video
        
        present(videoPlayer, animated: true, completion: {
            video.play()
        })
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
                storageRef.getMetadata(completion: { (metaData, error) in
                    if let validError = error {
                        print(validError.localizedDescription)
                    }
                    
                    if let validMetaData = metaData {
                        self.downloadURL = validMetaData.downloadURL()
                    }
                })
            }
        }
    }
}