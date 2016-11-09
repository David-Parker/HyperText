//
//  Client.swift
//  HyperText
//
//  Created by David Parker on 10/21/16.
//  Copyright © 2016 Group 14. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

class Client {
    static var loggedInUser:Client? = nil
    var firstName:String
    var lastName:String
    var email:String
    var settings:Settings? = nil
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
        let ref: FIRDatabaseReference! = FIRDatabase.database().reference()
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref.child("users/\(userID!)/textSpeed").setValue(newSettings.speed)
        ref.child("users/\(userID!)/speedReadingEnabled").setValue(newSettings.speedReading)
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
    
    func loadUsersBooks(uid:String, success: () -> Void, err: () -> Void) {
        let ref: FIRDatabaseReference! = FIRDatabase.database().reference()
        var count:Int = 0
        
        ref.child("books").child(uid).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let books = value?["books"] as! [String]
            
            let storageRef = FIRStorage.storage().reference()
            
            for book in books {
                let path:String = "Books/\(book).txt"
                let bookRef = storageRef.child(path)
                
                // Maximum book size is 1Mb, unless the size is increased here
                bookRef.dataWithMaxSize(1 * 1024 * 1024) { (data, error) -> Void in
                    if (error != nil) {
                        err()
                        // Uh-oh, an error occurred!
                    } else {
                        let dataString = String(data: data!, encoding: NSUTF8StringEncoding)
                        let bk:Book = Book(title: book, content: dataString!)
                        self.books.append(bk)
                        count = count + 1
                        
                        // Final book
                        if(count == books.count) {
                            success()
                        }
                    }
                }
            }
            
        }) { (error) in
            print(error.localizedDescription)
            err()
        }
    }
}
