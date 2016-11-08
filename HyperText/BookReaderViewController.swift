//
//  BookReaderViewController.swift
//  HyperText
//
//  Created by David Parker on 10/21/16.
//  Copyright © 2016 Group 14. All rights reserved.
//

import UIKit

class BookReaderViewController: UIViewController {

    @IBOutlet weak var textField: UITextView!
    var book:Book? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(book != nil) {
            self.title="\(book!.title)"
            self.textField.text = book!.content
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
