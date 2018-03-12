//
//  LoginViewController.swift
//  PhysioApp
//
//  Created by Philip Teow on 12/03/2018.
//  Copyright © 2018 Philip Teow. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage


class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton! {
        didSet {
            loginButton.layer.borderWidth = 2
            loginButton.layer.borderColor = UIColor(red: 154/255, green: 202/255, blue: 247/255, alpha: 1).cgColor
            loginButton.setTitleColor(UIColor.white, for: .normal)
            loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var signUpButton: UIButton! {
        didSet {
            signUpButton.layer.borderWidth = 2
            signUpButton.layer.borderColor = UIColor(red: 154/255, green: 202/255, blue: 247/255, alpha: 1).cgColor
            signUpButton.setTitleColor(UIColor.white, for: .normal)
        }
    }
    
        
    var ref : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        //Set Background Image
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "Gradient Background")
        self.view.insertSubview(backgroundImage, at: 0)
        
        checkUserIsLogin()
    }
    
    func checkUserIsLogin() {
        if Auth.auth().currentUser != nil {
            
            let sb = UIStoryboard(name: "Main", bundle: Bundle.main)
            
            guard let vc = sb.instantiateViewController(withIdentifier: "tabBarController") as? UITabBarController else {return}
            
            present(vc, animated: true, completion: nil)
        }
    }
    
    @objc func loginButtonTapped() {
        guard let email = emailTextField.text,
            let password = passwordTextField.text else {return}
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let validError = error {
                self.showAlert(withTitle: "Error", message: validError.localizedDescription)
            }
            
            if user != nil {
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
                
                let sb = UIStoryboard(name: "Main", bundle: Bundle.main)
                
                guard let vc = sb.instantiateViewController(withIdentifier: "tabBarController") as? UITabBarController else {return}
                
                self.present(vc, animated: true, completion: nil)
            }
        }
    }


}

