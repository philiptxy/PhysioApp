//
//  EditProgramViewController.swift
//  PhysioApp
//
//  Created by Terence Chua on 14/03/2018.
//  Copyright © 2018 Philip Teow. All rights reserved.
//

import UIKit

class EditProgramViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
        }
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "CustomBodyPartViewController") as? CustomBodyPartViewController else {return}
        
        vc.selectedExercises = selectedExercises
        
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var exercises : [Exercise] = []
    var selectedExercises : [Exercise] = []
    var selectedBodyParts : [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        NotificationCenter.default.addObserver(self, selector: #selector(getArray(notification:)), name: NSNotification.Name(rawValue: "BodyParts"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(getArray(notification:)), name: NSNotification.Name(rawValue: "Exercises"), object: nil)
    }
    
    @objc func getArray(notification: NSNotification) {
        
//        guard let userInfoBodyParts = notification.userInfo?["BodyParts"] as? [String] else {return}
        
        guard let userInfoExercises = notification.userInfo?["Exercises"] as? [Exercise] else {return}
        
//        selectedBodyParts = userInfoBodyParts
        selectedExercises = userInfoExercises
        
        tableView.reloadData()
    }


}

extension EditProgramViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedExercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = selectedExercises[indexPath.row].name
        
        return cell
    }
    
    
}
