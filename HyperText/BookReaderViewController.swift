//
//  BookReaderViewController.swift
//  HyperText
//
//  Created by David Parker on 10/21/16.
//  Copyright © 2016 Group 14. All rights reserved.
//

import UIKit

class BookReaderViewController: UIViewController {

    var book:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title="\(book)";

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
