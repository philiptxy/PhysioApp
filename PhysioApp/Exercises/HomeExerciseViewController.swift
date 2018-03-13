//
//  HomeExerciseViewController.swift
//  PhysioApp
//
//  Created by Philip Teow on 13/03/2018.
//  Copyright © 2018 Philip Teow. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class HomeExerciseViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    var selectedBodyPart : BodyPart = BodyPart()
    var exercises : [Exercise] = []
    var ref : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        
        loadInfo()
    }


    func loadInfo() {
        ref.child("bodyParts").child(selectedBodyPart.bodyPart).child("exercises").observe(.childAdded) { (snapshot) in
            guard let exerciseDict = snapshot.value as? [String : Any] else {return}
            let anExercise = Exercise(exerciseID: snapshot.key, dict: exerciseDict)
            
            DispatchQueue.main.async {
                self.exercises.append(anExercise)
                let indexPath = IndexPath(row: self.exercises.count - 1, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
}

extension HomeExerciseViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = exercises[indexPath.row].name
        
        return cell
    }
}

extension HomeExerciseViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "ExerciseVideoViewController") as? ExerciseVideoViewController else {return}
        
        let selectedExercise = exercises[indexPath.row]
        
        vc.selectedExercise = selectedExercise
        vc.selectedBodyPart = selectedBodyPart
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
