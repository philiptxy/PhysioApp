//
//  TimerViewController.swift
//  PhysioApp
//
//  Created by Terence Chua on 14/03/2018.
//  Copyright © 2018 Philip Teow. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {
    
    @IBOutlet weak var minuteLabel: UILabel! {
        didSet {
            minuteLabel.tag = 0
            minuteLabel.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(labelTapped(sender:)))
            minuteLabel.addGestureRecognizer(tap)
        }
    }
    
    @IBOutlet weak var secondLabel: UILabel! {
        didSet {
            secondLabel.tag = 1
            secondLabel.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(labelTapped(sender:)))
            secondLabel.addGestureRecognizer(tap)
        }
    }
    
    @IBOutlet weak var startButton: UIButton! {
        didSet {
            startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
            startButton.layer.cornerRadius = 10
            startButton.layer.borderWidth = 0
            
        }
    }
    
    var selectedPicker : Int = 0
    let minuteOptions = [00,01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30]
    let secondOptions = [00,05,10,15,20,25,30,35,40,45,50,55,60]
    var didSelect : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "Gradient Background")
        backgroundImage.alpha = 0.5
        self.view.insertSubview(backgroundImage, at: 0)
        
    }
    
    @objc func startButtonTapped() {
        
        guard let vc = navigationController?.storyboard?.instantiateViewController(withIdentifier: "CountdownViewController") as? CountdownViewController else {return}
        guard let minute = minuteLabel.text,
            let second = secondLabel.text,
            let intMinute = Int(minute),
            let intSecond = Int(second) else {return}
        
        vc.minute = intMinute
        vc.second = intSecond
        
        navigationController?.present(vc, animated: true, completion: nil)
    }
}

//----------------- PickerView -----------------
extension TimerViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    @objc func labelTapped(sender: UITapGestureRecognizer) {
        
        var sentBy = ""
        
       guard let label = sender.view else {return}
        
        if label.tag == 0 {
            sentBy = "minute"
        } else if label.tag == 1 {
            sentBy = "second"
        }
        
        didSelect = false
        
        var title = ""
        var message = "\n\n\n\n\n\n\n\n\n\n"
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.actionSheet)
        alert.isModalInPopover = true
        
        
        
        //Create a frame (placeholder/wrapper) for the picker and then create the picker
        var pickerFrame: CGRect = CGRect(x: 17, y: 52, width: view.frame.width*0.83, height: view.frame.height*0.2) // CGRectMake(left), top, width, height) - left and top are like margins
        var picker: UIPickerView = UIPickerView(frame: pickerFrame)
        
        /* If there will be 2 or 3 pickers on this view, I am going to use the tag as a way
         to identify them in the delegate and datasource.  This part with the tags is not required.
         I am doing it this way, because I have a variable, witch knows where the Alert has been invoked from.*/
        if(sentBy == "minute"){
            picker.tag = 1
        } else if (sentBy == "second"){
            picker.tag = 2
        } else {
            picker.tag = 0
        }
        
        //set the pickers datasource and delegate
        picker.delegate = self
        picker.dataSource = self
        
        //Add the picker to the alert controller
        alert.view.addSubview(picker);
        
        //Create the toolbar view - the view witch will hold our 2 buttons
        var toolFrame = CGRect(x: 17, y: 5, width: 270, height: 45)
        var toolView: UIView = UIView(frame: toolFrame);
        
        //add buttons to the view
        var buttonCancelFrame: CGRect = CGRect(x: 0, y: 7, width: 100, height: 30) //size & position of the button as placed on the toolView
        
        //Create the cancel button & set its title
        var buttonCancel: UIButton = UIButton(frame: buttonCancelFrame)
        buttonCancel.setTitle("Cancel", for: UIControlState.normal)
        buttonCancel.setTitleColor(UIColor.blue, for: UIControlState.normal)
        toolView.addSubview(buttonCancel); //add it to the toolView
        
        //Add the target - target, function to call, the event witch will trigger the function call
        buttonCancel.addTarget(self, action: #selector(cancelSelection(sender:)), for: .touchUpInside)
        
        
        //add buttons to the view
        var buttonOkFrame: CGRect = CGRect(x: toolView.frame.width-100+10, y: 7, width: 100, height: 30) //size & position of the button as placed on the toolView
        
        //Create the Select button & set the title
        var buttonOk: UIButton = UIButton(frame: buttonOkFrame)
        buttonOk.setTitle("Select", for: UIControlState.normal)
        buttonOk.setTitleColor(UIColor.blue, for: UIControlState.normal)
        toolView.addSubview(buttonOk); //add to the subview
        
        //Add the tartget. In my case I dynamicly set the target of the select button
        if sentBy == "minute" {
            buttonOk.accessibilityHint = "minute"
        } else if sentBy == "second" {
            buttonOk.accessibilityHint = "second"
        }
        buttonOk.addTarget(self, action: #selector(selectThis(sender:)), for: .touchUpInside)
        
        
        //add the toolbar to the alert controller
        alert.view.addSubview(toolView);
        
        self.present(alert, animated: true, completion: nil);
    }
    
    @objc func selectThis(sender: UIButton){
        // Your code when select button is tapped
        print("select")
        self.dismiss(animated: true, completion: nil)
        if sender.accessibilityHint == "minute" {
            minuteLabel.text = String(selectedPicker)
            
            if didSelect == false {
                minuteLabel.text = String(minuteOptions[0])
            }
        } else if sender.accessibilityHint == "second" {
            secondLabel.text = String(selectedPicker)
            
            if didSelect == false {
                secondLabel.text = String(secondOptions[0])
            }
        }
    }
    
    
    @objc func cancelSelection(sender: UIButton){
        print("Cancel")
        self.dismiss(animated: true, completion: nil);
        // We dismiss the alert. Here you can add your additional code to execute when cancel is pressed
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // returns number of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if(pickerView.tag == 1){
            return self.minuteOptions.count
        } else if(pickerView.tag == 2){
            return self.secondOptions.count
        } else  {
            return 0
        }
    }
    
    // Return the title of each row in your picker ... In my case that will be the profile name or the username string
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if(pickerView.tag == 1){
            return String(minuteOptions[row])
            
        } else if(pickerView.tag == 2) {
            return String(secondOptions[row])
            
        } else  {
            return ""
            
        }
        
    }
    
    
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        didSelect = true
        
        if(pickerView.tag == 1){
            self.selectedPicker = minuteOptions[row]
        } else if (pickerView.tag == 2){
            self.selectedPicker = secondOptions[row]
        }
        
        
    }
    
}

