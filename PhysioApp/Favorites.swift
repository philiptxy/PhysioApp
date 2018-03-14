//
//  Favorites.swift
//  PhysioApp
//
//  Created by Philip Teow on 13/03/2018.
//  Copyright © 2018 Philip Teow. All rights reserved.
//

import Foundation

class Favorites {
    
    var hip : [String: Any] = [:]
    var knee : [String : Any] = [:]
    var lowerBack : [String : Any] = [:]
    var neck : [String : Any] = [:]
    var shoulder : [String : Any] = [:]
    var wrist : [String : Any] = [:]

    init() {
        
    }
    
    init(dict: [String : Any]) {
        self.hip = dict["hip"] as? [String : Any] ?? [:]
        self.knee = dict["knee"] as? [String : Any] ?? [:]
        self.lowerBack = dict["lowerBack"] as? [String : Any] ?? [:]
        self.neck = dict["neck"] as? [String : Any] ?? [:]
        self.shoulder = dict["shoulder"] as? [String : Any] ?? [:]
        self.wrist = dict["wrist"] as? [String : Any] ?? [:]
        
    }
}

