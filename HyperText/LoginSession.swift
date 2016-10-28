//
//  LoginSession.swift
//  HyperText
//
//  Created by David Parker on 10/21/16.
//  Copyright © 2016 Group 14. All rights reserved.
//

import Foundation
import Firebase

class LoginSession {
    let hardEmail:String = "username"
    let hardPassword:String = "password"
    
    func checkLogin(email:String, password:String) -> Client? {
        var client:Client?
        
        FIRAuth.auth()?.signInWithEmail(email, password:password, completion: {
            (user, error) in
            if error != nil {
                // Error with registration.
                print("error \(email) \(password)")
                client = nil
            } else {
                print("success \(email) \(password)")
                client = Client.findClientByEmail(email)
            }
        })
        return client
    }

}

