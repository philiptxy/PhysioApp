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
    
    @IBOutlet weak var timerButton: UIBarButtonItem! {
        didSet {
            timerButton.setBackgroundImage(UIImage(named: "timer"), for: .normal, barMetrics: .default)
        }
    }
    
    @IBOutlet weak var editTableButton: UIBarButtonItem! {
        didSet {
            editTableButton.action = #selector(editTableButtonTapped)
            editTableButton.target = self
        }
    }
    
    @IBOutlet weak var editImageView: UIImageView! {
        didSet {
            editImageView.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(editImageViewTapped))
            editImageView.addGestureRecognizer(tap)
        }
    }
    
    @IBOutlet weak var editNameTextField: UITextField!
    
    @IBOutlet weak var cancelButton: UIButton! {
        didSet {
            cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var doneEditingButton: UIButton! {
        didSet {
            doneEditingButton.addTarget(self, action: #selector(doneEditingButtonTapped), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var datePicker: UIDatePicker! {
        didSet {
            datePicker.backgroundColor = UIColor.white
        }
    }
    
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
            setButton.layer.cornerRadius = 10
            setButton.layer.borderWidth = 1
          //  setButton.isEnabled = false
        }
    }
    @IBOutlet weak var removeButton: UIButton! {
        didSet {
            removeButton.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
            removeButton.layer.cornerRadius = 10
            removeButton.layer.borderWidth = 1
            removeButton.isEnabled = false
            removeButton.setTitleColor(UIColor.lightGray, for: .normal)
        }
    }
    
    @IBOutlet weak var reminderLabel: UILabel! {
        didSet {
            reminderLabel.layer.cornerRadius = 10
            reminderLabel.layer.borderWidth = 1
            reminderLabel.layer.masksToBounds = true
            reminderLabel.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    
    @IBOutlet weak var programName: UILabel! {
        didSet {
            programName.layer.cornerRadius = 10
            programName.layer.borderWidth = 1
            programName.layer.masksToBounds = true
            programName.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "CustomBodyPartViewController") as? CustomBodyPartViewController else {return}
        
        vc.selectedProgram = selectedProgram
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
    
//---------------------------------- Global Variables ----------------------------------------
    var alertController: UIAlertController?
    var alertTimer: Timer?
    var remainingTime = 0
    
    var exercises : [Exercise] = []
    var currentUserID : String = ""
    var selectedProgram : Program = Program()
    let scheduler = DLNotificationScheduler()
    
    var ref : DatabaseReference!
    
    
//------------------------------------  Functions ---------------------------------------------
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        currentUserID = Auth.auth().currentUser?.uid ?? ""
        
        loadProgramName()
        loadDatabase()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        editImageView.isHidden = false
        programName.isHidden = false
        editNameTextField.isHidden = true
        doneEditingButton.isHidden = true
        cancelButton.isHidden = true
    }
    
    
    func showAlertMsg(withTitle title: String, message: String?, time: Int) {
        
        guard (self.alertController == nil) else {
            print("Alert already displayed")
            return
        }
        
        self.remainingTime = time
        
        self.alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        self.alertTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
        
        self.present(self.alertController!, animated: true, completion: nil)
    }
    
    @objc func countDown() {
        self.remainingTime -= 1
        if (self.remainingTime < 0) {
            self.alertTimer?.invalidate()
            self.alertTimer = nil
            self.alertController!.dismiss(animated: true, completion: {
                self.alertController = nil
            })
        }
        
    }
    
    func loadProgramName() {
        ref.child("users").child(currentUserID).child("programs").child(selectedProgram.programID).observeSingleEvent(of: .value) { (snapshot) in
            guard let dict = snapshot.value as? [String : Any] else {return}
            DispatchQueue.main.async {
                self.programName.text = dict["name"] as? String ?? ""
            }
        }
    }
    
    func loadDatabase() {
        
        
        ref.child("users/\(currentUserID)/programs/\(selectedProgram.programID)/exercises").observe(.childAdded) { (snapshot) in
            
            if let dict = snapshot.value as? [String:Any] {
                let exercise = Exercise(exerciseID: snapshot.key, dict: dict)
                
                DispatchQueue.main.async {
                    self.exercises.append(exercise)
                    let indexPath = IndexPath(row: self.exercises.count - 1, section: 0)
                    self.tableView.insertRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }
    
    @objc func editTableButtonTapped() {
        if(self.tableView.isEditing == true)
        {
            self.tableView.isEditing = false
            editTableButton.title = "  Edit"
        }
        else
        {
            self.tableView.isEditing = true
            editTableButton.title = "  Done"
        }
    }
    
    @objc func editImageViewTapped() {
        editImageView.isHidden = true
        programName.isHidden = true
        editNameTextField.isHidden = false
        doneEditingButton.isHidden = false
        cancelButton.isHidden = false
        editNameTextField.text = programName.text
    }
    
    @objc func cancelButtonTapped() {
        editImageView.isHidden = false
        programName.isHidden = false
        editNameTextField.isHidden = true
        doneEditingButton.isHidden = true
        cancelButton.isHidden = true
    }
    
    @objc func doneEditingButtonTapped() {
        editImageView.isHidden = false
        programName.isHidden = false
        editNameTextField.isHidden = true
        doneEditingButton.isHidden = true
        cancelButton.isHidden = true
        
        guard let newProgramName = editNameTextField.text else {return}
        if programName.text != editNameTextField.text {
            showAlert(withTitle: "Name Change Successful", message: "Current program name changed to: \(newProgramName)")
        }
        programName.text = newProgramName
        
        ref.child("users").child(currentUserID).child("programs").child(selectedProgram.programID).updateChildValues(["name" : newProgramName])
    }
    
}

extension AddProgramViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.layer.cornerRadius = 10
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.layer.borderWidth = 2
        
        cell.textLabel?.text = exercises[indexPath.row].name
        
        let reps = exercises[indexPath.row].reps
        let sets = exercises[indexPath.row].sets
        
        cell.detailTextLabel?.text = "\(sets) sets, \(reps) reps"
        
        return cell
    }
    
    //------------------- moveRow and delete ---------------------
    
    // Override to support editing the table view.
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        var deletedExercise = Exercise()
        ref.child("users").child(currentUserID).child("programs").child(selectedProgram.programID).child("exercises").child(exercises[indexPath.row].exerciseID).observeSingleEvent(of: .value) { (snapshot) in
            guard let dict = snapshot.value as? [String : Any] else {return}
            deletedExercise = Exercise(exerciseID: snapshot.key, dict: dict)
            
            DispatchQueue.main.async {
                let newTotalTime = self.selectedProgram.totalTime - (deletedExercise.time)
                self.ref.child("users/\(self.currentUserID)/programs/\(self.selectedProgram.programID)").updateChildValues(["totalTime" : newTotalTime])
            }
        }
        
        let path = ref.child("users").child(currentUserID).child("programs").child(selectedProgram.programID).child("exercises").child(exercises[indexPath.row].exerciseID)
        
        deleteAlertConfirmation(indexPath: indexPath, path: path)
        
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let data = exercises.remove(at: sourceIndexPath.row)
        exercises.insert(data, at: destinationIndexPath.row)
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
        showAlertMsg(withTitle: "Daily Reminder Set", message: nil, time: 3)
        setButton.isEnabled = false
        removeButton.isEnabled = true
        setButton.setTitleColor(UIColor.lightGray, for: .normal)
        removeButton.setTitleColor(UIColor.black, for: .normal)
    }
    
    @objc func removeButtonTapped() {
        scheduler.cancelAlllNotifications()
        showAlertMsg(withTitle: "Daily Reminder Removed", message: nil, time: 1)
        setButton.isEnabled = true
        removeButton.isEnabled = false
        setButton.setTitleColor(UIColor.black, for: .normal)
        removeButton.setTitleColor(UIColor.lightGray, for: .normal)
    }
}

extension AddProgramViewController {
    func deleteAlertConfirmation(indexPath: IndexPath, path: DatabaseReference) {
        
        let alertController = UIAlertController(title: "Delete", message: "Are you sure you want to delete this?", preferredStyle: .alert)
        
        let delete = UIAlertAction(title: "Yes", style: .destructive) { (action) in
            self.exercises.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            
            path.removeValue()
            
            self.showAlertMsg(withTitle: "Exercise deleted succesfully", message: nil, time: 0)
        }
        
        let cancel = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        alertController.addAction(delete)
        alertController.addAction(cancel)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
