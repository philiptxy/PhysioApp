//
//  Program.swift
//  PhysioApp
//
//  Created by Terence Chua on 14/03/2018.
//  Copyright © 2018 Philip Teow. All rights reserved.
//

import Foundation

class Program {
    
    var programID : String = ""
    var name : String = ""
    var photoURL : String = ""
    var totalTime : Int = 0
    
    init() {
        
    }
    
    init(programID: String, dict: [String:Any]) {
        self.programID = programID
        self.name = dict["name"] as? String ?? ""
        self.photoURL = dict["photoURL"] as? String ?? ""
        self.totalTime = dict["totalTime"] as? Int ?? 0
    }
    
}


