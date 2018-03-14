//
//  CustomProgramViewController.swift
//  PhysioApp
//
//  Created by Terence Chua on 14/03/2018.
//  Copyright © 2018 Philip Teow. All rights reserved.
//

import UIKit

class CustomProgramViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
//            collectionView.delegate = self
        }
    }
    
    var programs : [Program] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    


}

extension CustomProgramViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return programs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CustomProgramCollectionViewCell else {return UICollectionViewCell()}
        
//        let photoURL = programs[indexPath.row].photoURL
        
        cell.nameLabel.text = programs[indexPath.row].name
        cell.timeLabel.text = String(programs[indexPath.row].totalTime)
        
        return cell
    }
    
}
