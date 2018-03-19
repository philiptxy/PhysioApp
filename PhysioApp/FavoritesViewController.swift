//
//  FavoritesViewController.swift
//  PhysioApp
//
//  Created by Philip Teow on 12/03/2018.
//  Copyright © 2018 Philip Teow. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class FavoritesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    var hipExercises : [String] = []
    var kneeExercises : [String] = []
    var lowerBackExercises : [String] = []
    var neckExercises : [String] = []
    var shoulderExercises : [String] = []
    var wristExercises : [String] = []
    var twoDimensionalArray : [[String]] = []

    var currentUserID : String = ""
    var ref : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        currentUserID = Auth.auth().currentUser?.uid ?? ""
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadInfo()
        
        hipExercises = []
        kneeExercises = []
        lowerBackExercises = []
        neckExercises = []
        shoulderExercises = []
        wristExercises = []
        twoDimensionalArray = []
        tableView.reloadData()
    }

    func loadInfo() {
        ref.child("users").child(currentUserID).child("favorites").observe(.value) { (snapshot) in
            guard let dict = snapshot.value as? [String : Any] else {return}
            let aFavorites = Favorites(dict: dict)
            
            for (key,_) in aFavorites.hip {
                self.hipExercises.append(key)
            }
            for (key,_) in aFavorites.knee {
                self.kneeExercises.append(key)
            }
            for (key,_) in aFavorites.lowerBack {
                self.lowerBackExercises.append(key)
            }
            for (key,_) in aFavorites.neck {
                self.neckExercises.append(key)
            }
            for (key,_) in aFavorites.shoulder {
                self.shoulderExercises.append(key)
            }
            for (key,_) in aFavorites.wrist {
                self.wristExercises.append(key)
            }
            
            if self.hipExercises.count == 0 {
                self.hipExercises.append("empty")
            }
            if self.kneeExercises.count == 0 {
                self.kneeExercises.append("empty")
            }
            if self.lowerBackExercises.count == 0 {
                self.lowerBackExercises.append("empty")
            }
            if self.neckExercises.count == 0 {
                self.neckExercises.append("empty")
            }
            if self.shoulderExercises.count == 0 {
                self.shoulderExercises.append("empty")
            }
            if self.wristExercises.count == 0 {
                self.wristExercises.append("empty")
            }
            
            self.twoDimensionalArray.append(self.hipExercises)
            self.twoDimensionalArray.append(self.kneeExercises)
            self.twoDimensionalArray.append(self.lowerBackExercises)
            self.twoDimensionalArray.append(self.neckExercises)
            self.twoDimensionalArray.append(self.shoulderExercises)
            self.twoDimensionalArray.append(self.wristExercises)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension FavoritesViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headers = ["Hip", "Knee", "Lower Back", "Neck", "Shoulder", "Wrist"]
//
//        let label = UILabel()
//        label.text = headers[section]
//        label.backgroundColor = UIColor.blue
//        return label
        
        let button = UIButton(type: .system)
        button.setTitle("Close", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor.yellow
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        
        button.addTarget(self, action: #selector(openCloseHandler), for: .touchUpInside)
        
        button.tag = section
        
        return button
    }
    
    @objc func openCloseHandler(button: UIButton) {
        let section = button.tag
        
        var indexPaths = [IndexPath]()
        for row in twoDimensionalArray[section].indices {
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        
        tableView.deleteRows(at: indexPaths, with: .fade)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return twoDimensionalArray.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if twoDimensionalArray[section][0] == "empty" {
            return 0
        }
        
        return twoDimensionalArray[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let bodyParts = ["hip", "knee", "lowerBack", "neck", "shoulder", "wrist"]
        
        //when using .value, snapshot.key is the last .child() in the code.
        //when using .childAdded, snapshot.key is each item inside the last .child() in the code.
        ref.child("bodyParts").child(bodyParts[indexPath.section]).child("exercises").child(twoDimensionalArray[indexPath.section][indexPath.row]).observeSingleEvent(of: .value) { (snapshot) in
            guard let dict = snapshot.value as? [String : Any] else {return}
            guard let name = dict["name"] as? String else {return}
            guard let difficulty = dict["difficulty"] as? String else {return}
            DispatchQueue.main.async {
                cell.textLabel?.text = name
                cell.detailTextLabel?.text = "Difficulty: \(difficulty)"
            }
            
        }
        return cell
    }
}

extension FavoritesViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = navigationController?.storyboard?.instantiateViewController(withIdentifier: "ExerciseVideoViewController") as? ExerciseVideoViewController else {return}
        let bodyParts = ["hip", "knee", "lowerBack", "neck", "shoulder", "wrist"]
        
        let selectedBodyPartName = bodyParts[indexPath.section]
        let selectedExerciseID = twoDimensionalArray[indexPath.section][indexPath.row]
        
        var selectedBodyPart = BodyPart()
        var selectedExercise = Exercise()
        
        ref.child("bodyParts").child(selectedBodyPartName).observe(.value) { (snapshot) in
            guard let dict = snapshot.value as? [String : Any] else {return}
            selectedBodyPart = BodyPart(bodyPart: snapshot.key, dict: dict)
        }
        
        ref.child("bodyParts").child(selectedBodyPartName).child("exercises").child(selectedExerciseID).observe(.value) { (snapshot) in
            guard let dict = snapshot.value as? [String : Any] else {return}
            selectedExercise = Exercise(exerciseID: snapshot.key, dict: dict)
            
            DispatchQueue.main.async {
                vc.selectedBodyPart = selectedBodyPart
                vc.selectedExercise = selectedExercise
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
        
        
        
    }
}
