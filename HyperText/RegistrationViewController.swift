//
//  RegistrationViewController.swift
//  HyperText
//
//  Created by David Parker on 10/21/16.
//  Copyright © 2016 Group 14. All rights reserved.
//

import UIKit
import Firebase

class RegistrationViewController: UIViewController {
    var ref: FIRDatabaseReference!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.pod 'Firebase/Auth'
    }
    
    @IBAction func registerButtonPressed(sender: AnyObject) {
        let email:String = emailTextField.text!
        let password:String = passwordTextField.text!
        let passwordConfirm:String = passwordConfirmTextField.text!
        let firstName:String = firstNameTextField.text!
        let lastName:String = lastNameTextField.text!
    
        // Empty fields
        if(email == "" || password == "" || firstName == "" || lastName == "") {
            let alertController = UIAlertController(title: "Registration Failed", message: "All fields must be filled out.", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
                print("OK")
            }
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        
        // Passwords don't match
        if(password != passwordConfirm) {
            let alertController = UIAlertController(title: "Registration Failed", message: "Passwords do not match.", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
                print("OK")
            }
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }

        FIRAuth.auth()?.createUserWithEmail(email, password:password, completion: {
            (user, error) in
            if error != nil {
                // Error with registration.
                let alertController = UIAlertController(title: "Registration Failed", message: "User already exists or password is not long enough.", preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
                  print("OK")
                }
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            } else {
                // Saves the user's info to the database
                self.ref = FIRDatabase.database().reference()
                self.ref.child("users").child(user!.uid).setValue(["email": email, "firstName": firstName, "lastName": lastName, "speedReadingEnabled": true, "textSpeed": 50, "faceBookAccount":"asdf"])
                
                self.navigationController?.popViewControllerAnimated(true)
            }
        })
    }
}
