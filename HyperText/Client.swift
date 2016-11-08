//
//  Client.swift
//  HyperText
//
//  Created by David Parker on 10/21/16.
//  Copyright © 2016 Group 14. All rights reserved.
//

import Foundation
import Firebase

class Client {
    var firstName:String
    var lastName:String
    var email:String
    var settings:Settings? = nil
    static var loggedInUser:Client? = nil
    var books:[Book] = [Book]()
    
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
    
    // Asynchornous database lookup for the user's data, calls the success closure on completeion
    class func setLoggedInUser(let uid:String, success: () -> Void, err: () -> Void) {
        let ref: FIRDatabaseReference! = FIRDatabase.database().reference()
        
        ref.child("users").child(uid).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let email = value?["email"] as! String
            let firstName = value?["firstName"] as! String
            let lastName = value?["lastName"] as! String
            
            self.loggedInUser = Client(firstName: firstName, lastName: lastName, email: email)
            self.loggedInUser?.settings = self.loggedInUser!.getSettingsForAccount()
            success()

        }) { (error) in
            print(error.localizedDescription)
            err()
        }
    }
    
    class func getLoggedInUser() -> Client? {
        return self.loggedInUser
    }
    
    class func loadUsersBooks(let uid:String, success: () -> Void, err: () -> Void) {
        let ref: FIRDatabaseReference! = FIRDatabase.database().reference()
        
        ref.child("books").child(uid).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let books = value?["books"] as! [String]
            
            let storageRef = FIRStorage.reference().child("folderName/file.jpg")
            success()
            
        }) { (error) in
            print(error.localizedDescription)
            err()
        }

    }
}
