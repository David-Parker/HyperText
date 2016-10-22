//
//  Client.swift
//  HyperText
//
//  Created by David Parker on 10/21/16.
//  Copyright © 2016 Group 14. All rights reserved.
//

import Foundation

class Client {
    var firstName:String
    var lastName:String
    var email:String
    var settings:Settings? = nil
    static var loggedInUser:Client? = nil
    
    init(let firstName:String, let lastName:String, let email:String) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
    }
    
    // Will need to retrieve the settings for the current user from the database
    func getSettingsForAccount() -> Settings {
        return Settings(speedReading: true, speed: 0.5, faceBookAccount: "johndoe@test.com")
    }
    
    func setNewSettings(let newSettings:Settings) {
        self.settings = newSettings
        // Save settings to DB
    }
    
    // Finds the user account in the database by email (primary key) then sets the state of the logged in user
    class func findClientByEmail(let email:String) -> Client? {
        self.loggedInUser = Client(firstName: "John", lastName: "Doe", email: "johndoe@test.com")
        self.loggedInUser?.settings = self.loggedInUser!.getSettingsForAccount()
        
        return loggedInUser
    }
    
    class func getLoggedInUser() -> Client? {
        return self.loggedInUser
    }
}