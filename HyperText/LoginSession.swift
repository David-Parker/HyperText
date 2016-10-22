//
//  LoginSession.swift
//  HyperText
//
//  Created by David Parker on 10/21/16.
//  Copyright © 2016 Group 14. All rights reserved.
//

import Foundation

class LoginSession {
    let hardEmail:String = "username"
    let hardPassword:String = "password"
    
    func checkLogin(let email:String, let password:String) -> Client? {
        if(email == hardEmail && password == hardPassword) {
            return Client.findClientByEmail(email)
        }
        else {
            return nil
        }
    }

}

