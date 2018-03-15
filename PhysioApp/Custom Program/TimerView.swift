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

    var hour : String = ""
    var minute : String = ""
    var second : String = ""

    
    override func awakeFromNib() {
        
        let timeString = "\(hour):\(minute):\(second)"
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        guard let time = formatter.date(from: timeString) else {return}
        
        
        let countdownLabel = CountdownLabel(frame: frame, date: time as NSDate)
        countdownLabel.start()
    }
    

}
