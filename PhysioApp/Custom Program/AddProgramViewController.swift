//
//  AddProgramViewController.swift
//  PhysioApp
//
//  Created by Terence Chua on 14/03/2018.
//  Copyright © 2018 Philip Teow. All rights reserved.
//

import UIKit
import DLLocalNotifications

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
    
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "CustomBodyPartViewController") as? CustomBodyPartViewController else {return}
        
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
    var exercises : [Exercise] = []
    
    var selectedProgram : Program = Program()
    let scheduler = DLNotificationScheduler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        programName.text = selectedProgram.name
        
    }


}

extension AddProgramViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = exercises[indexPath.row].name
        
        return cell
    }
    
}

extension AddProgramViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "ExerciseVideoViewController") as? ExerciseVideoViewController else {return}
        
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
