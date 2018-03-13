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
            //  collectionView.delegate = self
        }
    }
    
    var bodyParts : [BodyPart] = []
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        
    }
    
    func loadInfo() {
        ref.child("bodyParts").observe(.childAdded) { (snapshot) in
            guard let articleDict = snapshot.value as? [String : Any] else {return}
            let aBodyPart = BodyPart(bodyPart: snapshot.key, dict: articleDict)
            
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
        
        
        return cell
    }
}
//
//extension HomeBodyPartViewController : UICollectionViewDelegate {
//
//}

