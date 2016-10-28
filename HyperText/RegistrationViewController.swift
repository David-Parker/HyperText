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
        // TODO: associate first name/last name with user account
        // TODO: make sure passwords are matching/of appropriate strength 
        let email:String = emailTextField.text!
        let password:String = passwordTextField.text!

        FIRAuth.auth()?.createUserWithEmail(email, password:password, completion: {
            (user, error) in
            if error != nil {
                // Error with registration.
                let alertController = UIAlertController(title: "Registration not Available", message: "Registration not available right now.", preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
                  print("OK")
                }
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            } else {
                self.navigationController?.popViewControllerAnimated(true)
            }
        })
    }
}
