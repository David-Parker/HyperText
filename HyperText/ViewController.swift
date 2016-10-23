//
//  ViewController.swift
//  HyperText
//
//  Created by David Parker on 10/21/16.
//  Copyright © 2016 Group 14. All rights reserved.
//

import UIKit

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
        let login:LoginSession = LoginSession()
        let client:Client? = login.checkLogin(emailTextBox.text!, password: passwordTextBox.text!)
        
        if(client == nil) {
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
            // proceed with login, segue to main user view and pass the client object
            let segue:LibraryController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("library-tab") as! LibraryController
            
            let navController = UINavigationController(rootViewController: segue)
            
            self.presentViewController(navController, animated: true, completion: nil)
        }
        
    }

    @IBAction func loginButtonFacebookPressed(sender: AnyObject) {
        
    }
    
    @IBAction func createAccountButtonPressed(sender: AnyObject) {
        
    }
}

