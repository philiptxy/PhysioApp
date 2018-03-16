//
//  HomeBodyPartViewController.swift
//  PhysioApp
//
//  Created by Philip Teow on 12/03/2018.
//  Copyright © 2018 Philip Teow. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class HomeBodyPartViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    
    @IBAction func logOutButtonTapped(_ sender: UIBarButtonItem) {
        do{
            try Auth.auth().signOut()
            dismiss(animated: true, completion: nil)
        } catch {
            
        }
    }
    
    
    var bodyParts : [BodyPart] = []
    var ref: DatabaseReference!
    var customChecker : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        loadInfo()
    }
    
    func loadInfo() {
        ref.child("bodyParts").observe(.childAdded) { (snapshot) in
            guard let dict = snapshot.value as? [String : Any] else {return}
            let aBodyPart = BodyPart(bodyPart: snapshot.key, dict: dict)
            
            DispatchQueue.main.async {
                self.bodyParts.append(aBodyPart)
                let indexPath = IndexPath(row: self.bodyParts.count - 1, section: 0)
                self.collectionView.insertItems(at: [indexPath])
            }
            
            
        }
    }
    
    
}

extension HomeBodyPartViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bodyParts.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? BodyPartCollectionViewCell else {return UICollectionViewCell()}
        let currentBodyPart = bodyParts[indexPath.row]
        var bodyPartName = ""
        
        if currentBodyPart.bodyPart == "knee" {
            bodyPartName = "KNEE"
        } else if currentBodyPart.bodyPart == "lowerBack" {
            bodyPartName = "LOWER BACK"
        } else if currentBodyPart.bodyPart == "neck" {
            bodyPartName = "NECK"
        } else if currentBodyPart.bodyPart == "shoulder" {
            bodyPartName = "SHOULDER"
        } else if currentBodyPart.bodyPart == "wrist" {
            bodyPartName = "WRIST"
        } else if currentBodyPart.bodyPart == "hip" {
            bodyPartName = "HIP"
        }
        
        getImage(currentBodyPart.pictureUrl, cell.imageView)
        cell.label.text = bodyPartName
        
        return cell
    }
    

}

extension HomeBodyPartViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 2 - 5, height: view.frame.height / 2 - 10)
    }
}

extension HomeBodyPartViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "HomeExerciseViewController") as? HomeExerciseViewController else {return}
        
        let selectedBodyPart = bodyParts[indexPath.row]
        
        vc.selectedBodyPart = selectedBodyPart
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

