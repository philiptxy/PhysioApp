//
//  AddProgramViewController.swift
//  PhysioApp
//
//  Created by Terence Chua on 14/03/2018.
//  Copyright © 2018 Philip Teow. All rights reserved.
//

import UIKit

class AddProgramViewController: UIViewController {
    
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "EditProgramViewController") as? EditProgramViewController else {return}
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }


}
