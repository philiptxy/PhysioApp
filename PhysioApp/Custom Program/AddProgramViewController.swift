//
//  AddProgramViewController.swift
//  PhysioApp
//
//  Created by Terence Chua on 14/03/2018.
//  Copyright © 2018 Philip Teow. All rights reserved.
//

import UIKit
import DLLocalNotifications
import FirebaseDatabase
import FirebaseAuth

class AddProgramViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func datePickerChanged(_ sender: Any) {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.short
     //   dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        let strDate = dateFormatter.string(from: datePicker.date)
        print(strDate)
        
        
    }
    @IBOutlet weak var setButton: UIButton! {
        didSet {
            setButton.addTarget(self, action: #selector(setButtonTapped), for: .touchUpInside)
        }
    }
    @IBOutlet weak var removeButton: UIButton! {
        didSet {
            removeButton.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var programName: UILabel!
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "CustomBodyPartViewController") as? CustomBodyPartViewController else {return}
        
        vc.selectedProgram = selectedProgram
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
    var exercises : [Exercise] = []
    
    var selectedProgram : Program = Program()
    let scheduler = DLNotificationScheduler()
    
    var ref : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
//        programName.text = selectedProgram.name
        
        loadDatabase()
    }
    
    func loadDatabase() {
        guard let currentUserID = Auth.auth().currentUser?.uid else {return}
        
        ref.child("users/\(currentUserID)/programs/\(selectedProgram.programID)/exercises").observe(.childAdded) { (snapshot) in
            
            if let dict = snapshot.value as? [String:Any] {
                let exercise = Exercise(exerciseID: snapshot.key, dict: dict)

                DispatchQueue.main.async {
                    self.exercises.append(exercise)
                    let indexPath = IndexPath(row: self.exercises.count, section: 0)
                    self.tableView.insertRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }
    
}

extension AddProgramViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        loadDatabase()
        
        cell.textLabel?.text = exercises[indexPath.row].name
        
        let reps = exercises[indexPath.row].reps
        let sets = exercises[indexPath.row].sets
        
        cell.detailTextLabel?.text = "\(sets) sets, \(reps) reps"
        
        return cell
    }
    
}

extension AddProgramViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "ExerciseVideoViewController") as? ExerciseVideoViewController else {return}
        
        let selectedBodyPartStr = exercises[indexPath.row].bodyPart
        let selectedBodyPart = BodyPart(bodyPart: selectedBodyPartStr)
        
        let selectedExercise = Exercise(exerciseID: exercises[indexPath.row].exerciseID)
        
        vc.selectedBodyPart = selectedBodyPart
        vc.selectedExercise = selectedExercise
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

// -------------------- REMINDER ------------------------------------
extension AddProgramViewController {
    @objc func setButtonTapped() {
        scheduler.cancelAlllNotifications()
        let firstNotification = DLNotification(identifier: "reminder", alertTitle: "Reminder!", alertBody: "It is time to do your physiotherapy exercises", date: datePicker.date, repeats: .Daily)

        
        scheduler.scheduleNotification(notification: firstNotification)
        
    }
    
    @objc func removeButtonTapped() {
        scheduler.cancelAlllNotifications()
    }
}
