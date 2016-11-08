//
//  ViewController.swift
//  HyperText
//
//  Created by David Parker on 10/21/16.
//  Copyright © 2016 Group 14. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    @IBOutlet weak var emailTextBox: UITextField!
    @IBOutlet weak var passwordTextBox: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginButtonPressed(sender: AnyObject) {

        FIRAuth.auth()?.signInWithEmail(emailTextBox.text!, password:passwordTextBox.text!, completion: {
            (user, error) in
            if error != nil {
                // Error, email or password was invalid
                let alertController = UIAlertController(title: "Invalid Login", message: "Your email or password is not valid.", preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
                    print("OK")
                }
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                return
            }
            else {
                // Set the currently logged in user in memory
                Client.setLoggedInUser(user!.uid,
                    success: { () -> Void in
                        // Setup the user's library before moving to the library view controller
                        let ref = FIRDatabase.database().reference()
                        ref.child("books").child(user!.uid).setValue(["books": ["huckberry-fin.txt"]])
                        
                        
                        
                        
                        let segue:LibraryController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("library-tab") as! LibraryController
                    
                        let navController = UINavigationController(rootViewController: segue)
                    
                        self.presentViewController(navController, animated: true, completion: nil)
                    },
                    err: {() -> Void in
                        let alertController = UIAlertController(title: "Error", message: "There was an error loading your library..", preferredStyle: UIAlertControllerStyle.Alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
                            print("OK")
                        }
                        alertController.addAction(okAction)
                        self.presentViewController(alertController, animated: true, completion: nil)
                        return
                    }
                )
            }
        })
    }

    @IBAction func loginButtonFacebookPressed(sender: AnyObject) {
        
    }
    
    @IBAction func createAccountButtonPressed(sender: AnyObject) {
        
    }
}

