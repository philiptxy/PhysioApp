//
//  TimerView.swift
//  PhysioApp
//
//  Created by Philip Teow on 15/03/2018.
//  Copyright © 2018 Philip Teow. All rights reserved.
//

import UIKit
import CountdownLabel

class TimerView: UIView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var doneButton: UIButton! {
        didSet {
            doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        }
    }
    
    var hour : String = ""
    var minute : String = ""
    var second : String = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commoninit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commoninit()
    }
    
    private func commoninit() {
        Bundle.main.loadNibNamed("TimerView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        
        let timeString = "\(hour):\(minute):\(second)"
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
    //    guard let time = formatter.date(from: timeString) else {return}
        
        
        let rect = CGRect(x: 375/2, y: 554/2-25, width: 100, height: 50)
        
        let countdownLabel = CountdownLabel(frame: rect, minutes: 30)
        
        countdownLabel.backgroundColor = UIColor.red
        
        addSubview(countdownLabel)
        
        countdownLabel.start()
    }
    
    @objc func doneButtonTapped() {
        removeFromSuperview()
    }
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        let timeString = "\(hour):\(minute):\(second)"
//        let formatter = DateFormatter()
//        formatter.dateFormat = "HH:mm:ss"
//        guard let time = formatter.date(from: timeString) else {return}
//
//
//        let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
//
//        let countdownLabel = CountdownLabel(frame: rect, date: time as NSDate)
//
//        countdownLabel.backgroundColor = UIColor.red
//
//        addSubview(countdownLabel)
//
//
//        countdownLabel.start()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
//    override func draw(_ rect: CGRect) {
//        let timeString = "\(hour):\(minute):\(second)"
//        let formatter = DateFormatter()
//        formatter.dateFormat = "HH:mm:ss"
//        guard let time = formatter.date(from: timeString) else {return}
//
//        let rect = CGRect(x: 100, y: 200, width: 100, height: 100)
//
//        let countdownLabel = CountdownLabel(frame: rect, minutes: 30)
//
//        countdownLabel.backgroundColor = UIColor.red
//
//        addSubview(countdownLabel)
//
//
//        countdownLabel.start()
//    }
    
    

}
