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
            tableView.rowHeight = 122
            
            //            tableView.backgroundView = UIImageView(image: UIImage(named: "Gradient Background"))
            //        tableView.backgroundView?.alpha = 0.5
        }
    }
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    
    var selectedBodyPart : BodyPart = BodyPart()
    var exercises : [Exercise] = []
    var filteredExercises : [Exercise] = []
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
                self.filteredExercises.append(anExercise)
                let indexPath = IndexPath(row: self.exercises.count - 1, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
}

extension HomeExerciseViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredExercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        guard let cell = Bundle.main.loadNibNamed("ExerciseTableViewCell", owner: nil, options: nil)?.first as? ExerciseTableViewCell else {return UITableViewCell()}
        cell.selectionStyle = .none
        
        cell.layer.cornerRadius = 10
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 2
                
        cell.titlelabel.text = filteredExercises[indexPath.row].name
        cell.detailLabel.text = "Difficulty: \(filteredExercises[indexPath.row].difficulty)"
        
        if filteredExercises[indexPath.row].name == "Lying Hip Rotations" {
            cell.exerciseImageView.image = UIImage(named: "Lying Hip Rotations")
        } else if filteredExercises[indexPath.row].name == "Towel Assisted Knee Mobility" {
            cell.exerciseImageView.image = UIImage(named: "Towel Assisted Knee Mobility")
        } else if filteredExercises[indexPath.row].name == "Knee To Chest Stretch" {
            cell.exerciseImageView.image = UIImage(named: "Knee To Chest Stretch")
        } else if filteredExercises[indexPath.row].name == "Lunge Stretch" {
            cell.exerciseImageView.image = UIImage(named: "Lunge Stretch")
        } else if filteredExercises[indexPath.row].name == "Glute Bridge" {
            cell.exerciseImageView.image = UIImage(named: "Glute Bridge")
        } else if filteredExercises[indexPath.row].name == "Lower Back Side Bending" {
            cell.exerciseImageView.image = UIImage(named: "Lower Back Side Bending")
        } else if filteredExercises[indexPath.row].name == "Lower Back Stretching In Sitting" {
            cell.exerciseImageView.image = UIImage(named: "Lower Back Stretching In Sitting")
        } else if filteredExercises[indexPath.row].name == "Rotation To Both Sides In Sitting" {
            cell.exerciseImageView.image = UIImage(named: "Rotation To Both Sides In Sitting")
        } else if filteredExercises[indexPath.row].name == "Looking Over Both Shoulders" {
            cell.exerciseImageView.image = UIImage(named: "Looking Over Both Shoulders")
        } else if filteredExercises[indexPath.row].name == "1-Hand External Rotation" {
            cell.exerciseImageView.image = UIImage(named: "1 Hand External Rotation")
        } else if filteredExercises[indexPath.row].name == "1-Hand Internal Rotation" {
            cell.exerciseImageView.image = UIImage(named: "1 Hand Internal Rotation")
        } else if filteredExercises[indexPath.row].name == "Lateral Raise" {
            cell.exerciseImageView.image = UIImage(named: "Lateral Raise")
        } else if filteredExercises[indexPath.row].name == "Lying External Rotation" {
            cell.exerciseImageView.image = UIImage(named: "Lying External Rotation")
        } else if filteredExercises[indexPath.row].name == "Underhand Pull Aparts" {
            cell.exerciseImageView.image = UIImage(named: "Underhand Pull Aparts")
        } else if filteredExercises[indexPath.row].name == "Bending The Wrist Forwards" {
            cell.exerciseImageView.image = UIImage(named: "Bending The Wrist Forwards")
        } else {
            cell.exerciseImageView.image = UIImage(named: "Empty Star")
        }
        
        cell.layoutIfNeeded()

        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layoutSubviews()
    }
}

extension HomeExerciseViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "ExerciseVideoViewController") as? ExerciseVideoViewController else {return}
        
        let selectedExercise = filteredExercises[indexPath.row]
        
        vc.selectedExercise = selectedExercise
        vc.selectedBodyPart = selectedBodyPart
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeExerciseViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            filteredExercises = exercises
            tableView.reloadData()
            return
        }

        //true - not filtered out
        filteredExercises = exercises.filter({ (exercise) -> Bool in
            exercise.name.lowercased().contains(searchText.lowercased())
        })
        self.tableView.reloadData()

    }
    
    
    
    //    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
    //        filteredCandies = candies.filter({( candy : Candy) -> Bool in
    //            return candy.name.lowercased().contains(searchText.lowercased())
    //        })
    //
    //        tableView.reloadData()
    //    }
}


