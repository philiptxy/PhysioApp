//
//  CustomProgramViewController.swift
//  PhysioApp
//
//  Created by Terence Chua on 14/03/2018.
//  Copyright © 2018 Philip Teow. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class CustomProgramViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        
        
        
        let path = ref.child("users").child(currentUserID).child("programs").childByAutoId()
        
        ref.child("users").child(currentUserID).child("programs").child(path.key).updateChildValues(["name" : "Program Name", "totalTime" : 0])
        
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "AddProgramViewController") as? AddProgramViewController else {return}
        
        let dict : [String : Any] = ["name" : "Program Name"]
        let aProgram = Program(programID: path.key, dict: dict)
        
        vc.selectedProgram = aProgram
        
        navigationController?.pushViewController(vc, animated: true)
        
        
        
//        ref.child("users").child(currentUserID).child("programs").child(key).observe(.value) { (snapshot) in
//            guard let dict = snapshot.value as? [String : Any] else {return}
//            let aProgram = Program(programID: snapshot.key, dict: dict)
//            DispatchQueue.main.async {
//                vc.selectedProgram = aProgram
//
//                    self.navigationController?.pushViewController(vc, animated: true)
//            }
//        }
        
        
//        ref
    }
    
    var ref : DatabaseReference!
    var currentUserID : String = ""
    var programs : [Program] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        currentUserID = Auth.auth().currentUser?.uid ?? ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        programs = []
        loadPrograms()
    }
    
    
    func loadPrograms() {
        ref.child("users").child(currentUserID).child("programs").observe(.childAdded) { (snapshot) in
            guard let dict = snapshot.value as? [String : Any] else {return}
            let aProgram = Program(programID: snapshot.key, dict: dict)
            
            DispatchQueue.main.async {
                self.programs.append(aProgram)
                self.collectionView.reloadData()
            }
            
        }
    }

}

extension CustomProgramViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return programs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CustomProgramCollectionViewCell else {return UICollectionViewCell()}
        
//        let photoURL = programs[indexPath.row].photoURL
        getImage("https://static1.squarespace.com/static/55a91762e4b0b8b2c8ec1996/55b270bce4b09435f235ba17/55b2715be4b09f505f14e9d0/1437757789668/Photo+2014-11-09%2C+12+38+07+PM.jpg", cell.imageView)
        cell.nameLabel.text = programs[indexPath.row].name
        cell.timeLabel.text = "Estimated Time : \(String(programs[indexPath.row].totalTime)) minutes"
        
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
