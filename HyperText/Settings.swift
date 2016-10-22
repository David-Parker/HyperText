//
//  Settings.swift
//  HyperText
//
//  Created by David Parker on 10/21/16.
//  Copyright © 2016 Group 14. All rights reserved.
//

import Foundation

class Settings {
    var speedReading:Bool
    var speed:Float
    var faceBookAccount:String
    
    init(let speedReading:Bool, let speed:Float, let faceBookAccount:String) {
        self.speedReading = speedReading
        self.speed = speed
        self.faceBookAccount = faceBookAccount
    }
}