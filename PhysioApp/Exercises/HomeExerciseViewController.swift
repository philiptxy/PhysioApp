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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = filteredExercises[indexPath.row].name
        
        //cell.textLabel?.
        
        //        cell.backgroundView = UIImageView(image: UIImage(named: "Gradient Background"))
        //
        //        cell.backgroundView?.alpha = 0.5
        
        return cell
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


