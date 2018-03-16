//
//  BodyPart.swift
//  PhysioApp
//
//  Created by Philip Teow on 12/03/2018.
//  Copyright © 2018 Philip Teow. All rights reserved.
//

import Foundation

class BodyPart {
    
    var bodyPart : String = ""
    var exercises : [String : Any] = [:]
    var pictureUrl : String = ""
    
    
    init() {
        
    }
    
    init(bodyPart: String) {
        self.bodyPart = bodyPart
    }
    
    init(bodyPart: String, dict: [String : Any]) {
        self.bodyPart = bodyPart
        self.exercises = dict["exercise"] as? [String : Any] ?? [:]
        self.pictureUrl = dict["pictureUrl"] as? String ?? ""
    }
    
    
    
    
}
