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
    class func getSettingsForAccount() -> Settings {
        return self.loggedInUser!.settings!
    }
    
    class func setNewSettings(let newSettings:Settings) {
        // Save settings to DB
        let ref: FIRDatabaseReference! = FIRDatabase.database().reference()
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref.child("users/\(userID!)/textSpeed").setValue(newSettings.speed)
        ref.child("users/\(userID!)/speedReadingEnabled").setValue(newSettings.speedReading)
        let fbAccount = self.loggedInUser?.settings!.faceBookAccount
        self.loggedInUser?.settings = Settings(speedReading: newSettings.speedReading, speed: newSettings.speed, faceBookAccount: fbAccount!)
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
            let speed = value?["textSpeed"] as! Float
            let speedReadingEnabled = value?["speedReadingEnabled"] as! Bool
            let fbAccount = value?["faceBookAccount"] as! String
                
            self.loggedInUser = Client(firstName: firstName, lastName: lastName, email: email)
            self.loggedInUser?.settings = Settings(speedReading: speedReadingEnabled, speed: speed, faceBookAccount: fbAccount)
            success()

        }) { (error) in
            print(error.localizedDescription)
            err()
        }
    }
    
    class func getLoggedInUser() -> Client? {
        return self.loggedInUser
    }
    
    class func signOut() {
        loggedInUser = nil
    }
    
    func loadUsersBooks(uid:String, success: () -> Void, err: () -> Void) {
        self.books.removeAll()
        let ref: FIRDatabaseReference! = FIRDatabase.database().reference()
        var count:Int = 0
        
        ref.child("books").child(uid).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let books = value?["books"] as! [String]
            
            let storageRef = FIRStorage.storage().reference()
            
            for book in books {
                let path:String = "Books/\(book).txt"
                let coverPath:String = "Covers/\(book)-cover.png"
                let bookRef = storageRef.child(path)
                let coverRef = storageRef.child(coverPath)
                
                // Maximum book size is 1Mb, unless the size is increased here
                bookRef.dataWithMaxSize(1 * 1024 * 1024) { (data, error) -> Void in
                    coverRef.dataWithMaxSize(1 * 1024 * 1024) { (data2, error2) -> Void in
                        if (error2 != nil) {
                            err()
                            // Uh-oh, an error occurred!
                        }
                        else {
                            if (error != nil) {
                                err()
                                // Uh-oh, an error occurred!
                            }
                            else {
                                let dataString = String(data: data!, encoding: NSUTF8StringEncoding)
                                let decodedImage:UIImage! = UIImage(data: data2!)
                                
                                let bk:Book = Book(title: book, content: dataString!, cover: decodedImage!)
                                self.books.append(bk)
                                count = count + 1
                                
                                // Final book
                                if(count == books.count) {
                                    self.books.sortInPlace({$0.title < $1.title})
                                    success()
                                }
                            }
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
