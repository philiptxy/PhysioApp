//
//  CustomBodyPartViewController.swift
//  PhysioApp
//
//  Created by Terence Chua on 15/03/2018.
//  Copyright © 2018 Philip Teow. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class CustomBodyPartViewController: UIViewController {
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    @IBOutlet weak var customView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var setsTextField: UITextField!
    
    @IBOutlet weak var repsTextField: UITextField!
    
    @IBOutlet weak var confirmButton: UIButton!
    
    
    
    
    var selectedExercises : [Exercise] = []
    var selectedBodyParts : [String] = []
    
    var selectedProgramID : String = ""
    var selectedExerciseID : String = ""
    var selectedBodyPart : String = ""
    var selectedExercise : Exercise = Exercise()
    
    var hipExercises : [Exercise] = []
    var kneeExercises : [Exercise] = []
    var lowerBackExercises : [Exercise] = []
    var neckExercises : [Exercise] = []
    var shoulderExercises : [Exercise] = []
    var wristExercises : [Exercise] = []
    var twoDimensionalArray : [[Exercise]] = []
    
    var currentUserID : String = ""
    var ref : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        currentUserID = Auth.auth().currentUser?.uid ?? ""
        
        customView.isHidden = true
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
    
    func loadCustomView() {
        customView.isHidden = false
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    @objc func confirmButtonTapped() {
        if let sets = setsTextField.text,
            let reps = repsTextField.text,
            let currentUserID = Auth.auth().currentUser?.uid {
           
            let exerciseDict : [String : Any] = ["name" : selectedExercise.name, "sets" : sets, "reps" : reps, "bodyPart" : selectedBodyPart]
            ref.child("users").child(currentUserID).child("programs").child(selectedProgramID).child("exercises").child(selectedExerciseID).setValue(exerciseDict)
            
            customView.isHidden = true
            setsTextField.text = ""
            repsTextField.text = ""
            nameLabel.text = ""
            
            
            self.dismiss(animated: true, completion: nil)
        }
        
        
    }
    
    func loadInfo() {
        
//        let bodyParts = ["hip", "knee", "lowerBack", "neck", "shoulder", "wrist"]
        
//        for each in bodyParts {
//            ref.child("bodyParts").child(each).child("exercises").observe(.childAdded) { (snapshot) in
//                guard let dict = snapshot.value as? [String : Any] else {return}
//                let hipExercise = Exercise(exerciseID: snapshot.key, dict: dict)
//
//                self.hipExercises.append(hipExercise)
//            }
//        }
        
        ref.child("bodyParts").child("hip").child("exercises").observe(.childAdded) { (snapshot) in
            guard let dict = snapshot.value as? [String : Any] else {return}
            let hipExercise = Exercise(exerciseID: snapshot.key, dict: dict)
            
            self.hipExercises.append(hipExercise)
        }
        ref.child("bodyParts").child("knee").child("exercises").observe(.childAdded) { (snapshot) in
            guard let dict = snapshot.value as? [String : Any] else {return}
            let kneeExercise = Exercise(exerciseID: snapshot.key, dict: dict)
            
            self.kneeExercises.append(kneeExercise)
        }
        ref.child("bodyParts").child("lowerBack").child("exercises").observe(.childAdded) { (snapshot) in
            guard let dict = snapshot.value as? [String : Any] else {return}
            let lowerBackExercise = Exercise(exerciseID: snapshot.key, dict: dict)
            
            self.lowerBackExercises.append(lowerBackExercise)
        }
        ref.child("bodyParts").child("neck").child("exercises").observe(.childAdded) { (snapshot) in
            guard let dict = snapshot.value as? [String : Any] else {return}
            let neckExercise = Exercise(exerciseID: snapshot.key, dict: dict)
            
            self.neckExercises.append(neckExercise)
        }
        ref.child("bodyParts").child("shoulder").child("exercises").observe(.childAdded) { (snapshot) in
            guard let dict = snapshot.value as? [String : Any] else {return}
            let shoulderExercise = Exercise(exerciseID: snapshot.key, dict: dict)
            
            self.shoulderExercises.append(shoulderExercise)
        }
        ref.child("bodyParts").child("wrist").child("exercises").observe(.childAdded) { (snapshot) in
            guard let dict = snapshot.value as? [String : Any] else {return}
            let wristExercise = Exercise(exerciseID: snapshot.key, dict: dict)
            
            self.wristExercises.append(wristExercise)
            
            DispatchQueue.main.async {
                self.twoDimensionalArray.append(self.hipExercises)
                self.twoDimensionalArray.append(self.kneeExercises)
                self.twoDimensionalArray.append(self.lowerBackExercises)
                self.twoDimensionalArray.append(self.neckExercises)
                self.twoDimensionalArray.append(self.shoulderExercises)
                self.twoDimensionalArray.append(self.wristExercises)
                
                self.tableView.reloadData()
            }
        }
    }
}


extension CustomBodyPartViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headers = ["Hip", "Knee", "Lower Back", "Neck", "Shoulder", "Wrist"]
        let label = UILabel()
        label.text = headers[section]
        label.backgroundColor = UIColor.blue
        return label
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return twoDimensionalArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return twoDimensionalArray[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = twoDimensionalArray[indexPath.section][indexPath.row].name
        
        ref.child("users/\(currentUserID)/programs/\(selectedProgramID)/exercises").observe(.childAdded) { (snapshot) in
            
            if snapshot.key == self.twoDimensionalArray[indexPath.section][indexPath.row].exerciseID {
                cell.selectionStyle = UITableViewCellSelectionStyle.gray
                cell.isUserInteractionEnabled = false
                cell.textLabel?.isEnabled = false
            }
            
        }
        
        return cell
    }
    
}

extension CustomBodyPartViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        guard let currentUserID = Auth.auth().currentUser?.uid else {return}
//
//        guard let selectedCell : UITableViewCell = tableView.cellForRow(at: indexPath) else {return}
//        selectedCell.contentView.backgroundColor = UIColor.red
//
        let bodyParts = ["hip", "knee", "lowerBack", "neck", "shoulder", "wrist"]
        
        selectedBodyPart = bodyParts[indexPath.section]
        selectedExercise = twoDimensionalArray[indexPath.section][indexPath.row]
        selectedExerciseID = selectedExercise.exerciseID
        
        nameLabel.text = selectedExercise.name

        loadCustomView()
    }
}



