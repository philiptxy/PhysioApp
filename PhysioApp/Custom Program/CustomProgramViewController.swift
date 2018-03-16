//
//  CustomProgramViewController.swift
//  PhysioApp
//
//  Created by Terence Chua on 14/03/2018.
//  Copyright © 2018 Philip Teow. All rights reserved.
//

import UIKit
import FirebaseAuth

class CustomProgramViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "AddProgramViewController") as? AddProgramViewController else {return}
        
//        ref
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

extension CustomProgramViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "AddProgramViewController") as? AddProgramViewController else {return}
        
        let selectedProgram = programs[indexPath.row]
        
        vc.selectedProgram = selectedProgram
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
