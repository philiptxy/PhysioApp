//
//  TimerViewController.swift
//  PhysioApp
//
//  Created by Terence Chua on 14/03/2018.
//  Copyright © 2018 Philip Teow. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {

    @IBOutlet weak var hourTextField: UITextField!
    @IBOutlet weak var minuteTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var startButton: UIButton! {
        didSet {
            startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @objc func startButtonTapped() {
        guard let hour = hourTextField.text,
            let minute = minuteTextField.text,
            let second = secondTextField.text else {return}
        
        let timer = TimerView()
        
        timer.hour = hour
        timer.minute = minute
        timer.second = second
        
        view.addSubview(timer)
    }
 

}
