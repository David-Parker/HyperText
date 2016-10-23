//
//  SettingsViewController.swift
//  HyperText
//
//  Created by David Parker on 10/21/16.
//  Copyright © 2016 Group 14. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var speedReadingSwitch: UISwitch!
    @IBOutlet weak var textSpeedSlider: UISlider!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        let client:Client? = Client.getLoggedInUser()
        
        if(client == nil) {
            print("Error: the client was not setup properly")
            return
        }
        
        speedReadingSwitch.on = client!.settings!.speedReading
        textSpeedSlider.value = client!.settings!.speed
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func disconnectFacebook(sender: AnyObject) {
        
    }
    
    @IBAction func applySettings(sender: AnyObject) {
        let client:Client? = Client.getLoggedInUser()
        
        if(client == nil) {
            print("Error: the client was not setup properly")
            return
        }
        
        let newSettings:Settings = Settings(speedReading: speedReadingSwitch.on, speed: textSpeedSlider.value, faceBookAccount: "facebook")
        
        client!.setNewSettings(newSettings)
        
        let alertController = UIAlertController(title: "Success", message: "Your settings were saved.", preferredStyle: UIAlertControllerStyle.Alert)

        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
            print("OK")
        }
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
        }
}
