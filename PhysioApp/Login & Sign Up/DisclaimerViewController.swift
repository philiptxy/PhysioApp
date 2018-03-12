//
//  DisclaimerViewController.swift
//  PhysioApp
//
//  Created by Terence Chua on 12/03/2018.
//  Copyright © 2018 Philip Teow. All rights reserved.
//

import UIKit

class DisclaimerViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.textColor = UIColor.white
        }
    }
    
    @IBOutlet weak var textView: UITextView! {
        didSet {
            textView.textColor = UIColor.white
        }
    }
    
    @IBOutlet weak var understoodButton: UIButton! {
        didSet {
            understoodButton.layer.borderWidth = 2
            understoodButton.layer.borderColor = UIColor(red: 154/255, green: 202/255, blue: 247/255, alpha: 1).cgColor
            understoodButton.setTitleColor(UIColor.white, for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set Background Image
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "Gradient Background")
        self.view.insertSubview(backgroundImage, at: 0)
        
    }


}
