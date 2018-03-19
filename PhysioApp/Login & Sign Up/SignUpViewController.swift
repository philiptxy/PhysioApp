//
//  SignUpViewController.swift
//  PhysioApp
//
//  Created by Terence Chua on 12/03/2018.
//  Copyright © 2018 Philip Teow. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.textColor = UIColor.white
        }
    }
    
    @IBOutlet weak var emailLabel: UILabel! {
        didSet {
            emailLabel.textColor = UIColor.white
        }
    }
    
    @IBOutlet weak var passwordLabel: UILabel! {
        didSet {
            passwordLabel.textColor = UIColor.white
        }
    }
    
    @IBOutlet weak var confirmPasswordLabel: UILabel! {
        didSet {
            confirmPasswordLabel.textColor = UIColor.white
        }
    }
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton! {
        didSet {
            signUpButton.layer.borderWidth = 2
            signUpButton.layer.borderColor = UIColor(red: 154/255, green: 202/255, blue: 247/255, alpha: 1).cgColor
            signUpButton.setTitleColor(UIColor.white, for: .normal)
            signUpButton.addTarget(self, action: #selector(signUpUser), for: .touchUpInside)
        }
    }
    
    var ref : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)]
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationItem.title = "Sign Up"
        
        //Set Background Image
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "Gradient Background")
        self.view.insertSubview(backgroundImage, at: 0)
        
    }
    
    @objc func signUpUser() {
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            let confirmPassword = confirmPasswordTextField.text else {return}
        
        //Input Validation
        if !email.contains("@") {
            showAlert(withTitle: "Invalid Email Format", message: "Please input a valid email")
        } else if password.count < 7 {
            showAlert(withTitle: "Invalid Password", message: "Password must be at least 7 characters long")
        } else if confirmPassword != password {
            showAlert(withTitle: "Passwords Do Not Match", message: "Please enter the same passwords")
        } else {
            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                
                //Error
                if let validError = error {
                    self.showAlert(withTitle: "ERROR", message: validError.localizedDescription)
                }
                
                
                //Successful Creation of New User
                if let validUser = user {
                    
                    let newUser : [String : Any] = ["email" : email]
                    
                    self.ref.child("users").child(validUser.uid).setValue(newUser)
                    
                    let sb = UIStoryboard(name: "Main", bundle: Bundle.main)
                    
                    guard let vc = sb.instantiateViewController(withIdentifier: "tabBarController") as? UITabBarController else {return}
                    
                    self.navigationController?.popToRootViewController(animated: false)
                    
                    self.present(vc, animated: false, completion: nil)
                }
            })
        }
    }
    
    
    

}
