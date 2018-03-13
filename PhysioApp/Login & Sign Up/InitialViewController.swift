//
//  LoginViewController.swift
//  PhysioApp
//
//  Created by Philip Teow on 12/03/2018.
//  Copyright © 2018 Philip Teow. All rights reserved.
//

import UIKit
import FirebaseAuth

class InitialViewController: UIViewController {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var message: UITextView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var loginButton: UIButton! {
        didSet {
            loginButton.layer.borderWidth = 2
            loginButton.layer.borderColor = UIColor(red: 154/255, green: 202/255, blue: 247/255, alpha: 1).cgColor
            loginButton.setTitleColor(UIColor.white, for: .normal)
            
        }
    }
    
    @IBOutlet weak var signUpButton: UIButton! {
        didSet {
            signUpButton.layer.borderWidth = 2
            signUpButton.layer.borderColor = UIColor(red: 154/255, green: 202/255, blue: 247/255, alpha: 1).cgColor
            signUpButton.setTitleColor(UIColor.white, for: .normal)
        }
    }
    
    var messages : [String] = []
    
    var index : Int = 0
    
    var firstTimeChecker : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messages = ["Physiotherapy for everyone", "Millions of exercises and workouts on PhysioApp", "Personalized program to match your preferences"]
        
        checkUserIsLogin()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        if firstTimeChecker != false {
            backgroundImage.alpha = 0.0
            loginButton.alpha = 0.0
            signUpButton.alpha = 0.0
            message.alpha = 0.0
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        UIView.animate(withDuration: 1, delay: 0.0, options: [], animations: {
            
            //display background image
            self.backgroundImage.alpha = 1.0
            self.loginButton.alpha = 1.0
            self.signUpButton.alpha = 1.0
        }, completion: nil)
        
        UIView.animate(withDuration: 2.0, delay: 0.5, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.6, options: [], animations: {
            
            self.titleLabel.alpha = 1.0
            
            if self.firstTimeChecker == true {
                self.titleLabel.center.y += 30
                self.firstTimeChecker = false
            }
            
        }, completion: { _ in
            
            self.showMessages()
            
            
        })
        
    }
    
    func checkUserIsLogin() {
        if Auth.auth().currentUser != nil {
            
            let sb = UIStoryboard(name: "Main", bundle: Bundle.main)
            
            guard let vc = sb.instantiateViewController(withIdentifier: "tabBarController") as? UITabBarController else {return}
            
            present(vc, animated: true, completion: nil)
        }
    }
    
    func showMessages() {
        
        let message = self.messages[index]
        self.message.text = message
        
        self.message.center.y += 30.0
        
        UIView.animateKeyframes(withDuration: 10.0, delay: 0.0, options: [], animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.10, animations: {
                self.message.alpha = 0.5
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.10, relativeDuration: 0.05, animations: {
                self.keyframeAnimation()
            })

            
            UIView.addKeyframe(withRelativeStartTime: 0.90, relativeDuration: 0.05, animations: {
                self.message.alpha = 0.0
            })
            
        }, completion: { _ in
            
            if self.index == self.messages.count - 1 {
                self.index = 0
            } else {
                self.index += 1
            }
            
            self.showMessages()
            
        })
        
    }
    
    func keyframeAnimation() {
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: [.curveEaseOut], animations: {
            
            self.message.center.y -= 30
            
        }, completion: nil)
    }
    
    
    
    
}

