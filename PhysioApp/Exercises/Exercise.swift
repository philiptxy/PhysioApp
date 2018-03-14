//
//  Exercise.swift
//  PhysioApp
//
//  Created by Philip Teow on 13/03/2018.
//  Copyright © 2018 Philip Teow. All rights reserved.
//

import Foundation

class Exercise {
    
    var exerciseID : String = ""
    var name : String = ""
    var videoUrl : String = ""
    var description : String = ""
    
    init() {
        
    }
    
    init(exerciseID : String, dict : [String : Any]) {
        self.exerciseID = exerciseID
        self.name = dict["name"] as? String ?? ""
        self.videoUrl = dict["videoUrl"] as? String ?? ""
        self.description = dict["description"] as? String ?? ""

    }
}