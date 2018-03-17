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
    var reps : String = ""
    var sets : String = ""
    var bodyPart : String = ""
    var time : Int = 0
    
    init() {
        
    }
    
    init(exerciseID : String) {
        self.exerciseID = exerciseID
    }
    
    init(exerciseID : String, dict : [String : Any]) {
        self.exerciseID = exerciseID
        self.name = dict["name"] as? String ?? ""
        self.videoUrl = dict["videoUrl"] as? String ?? ""
        self.description = dict["description"] as? String ?? ""
        self.sets = dict["sets"] as? String ?? ""
        self.reps = dict["reps"] as? String ?? ""
        self.bodyPart = dict["bodyPart"] as? String ?? ""
        self.time = dict["time"] as? Int ?? 0

    }
}
