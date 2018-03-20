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
        //loadPrograms()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        programs = []
        loadPrograms()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //programs = []
        //        loadPrograms()
    }
    
    
    func loadPrograms() {
        ref.child("users").child(currentUserID).child("programs").observe(.childAdded) { (snapshot) in
            guard let dict = snapshot.value as? [String : Any] else {return}
            let aProgram = Program(programID: snapshot.key, dict: dict)
            
            DispatchQueue.main.async {
                self.programs.append(aProgram)
                self.collectionView.reloadData()
                //let indexPath = IndexPath(item: self.programs.count - 1, section: 0)
                //self.collectionView.insertItems(at: [indexPath])
            }
            
        }
        
        //        ref.child("users").child(currentUserID).child("programs").observe(.childChanged) { (snapshot) in
        //            guard let dict = snapshot.value as? [String : Any] else {return}
        //
        //            for (index, program) in self.programs.enumerated() {
        //                if program.programID == snapshot.key {
        //                    DispatchQueue.main.async {
        //                        let aProgram = Program(programID: snapshot.key, dict: dict)
        //                        self.programs[index] = aProgram
        //                        let indexPath = IndexPath(item: self.programs.count - 1, section: 0)
        //                        self.collectionView.reloadItems(at: [indexPath])
        //                        return
        //                    }
        //                }
        //            }
        //
        //        }
    }
    
}

extension CustomProgramViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return programs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CustomProgramCollectionViewCell else {return UICollectionViewCell()}
        
        cell.layer.cornerRadius = 10
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.layer.borderWidth = 2
        
        //        let photoURL = programs[indexPath.row].photoURL
        cell.nameLabel.text = programs[indexPath.row].name
        cell.timeLabel.text = "\(String(programs[indexPath.row].totalTime)) mins"
        
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

extension CustomProgramViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 2 - 15, height: view.frame.height / 3 - 10)
    }
    
}
