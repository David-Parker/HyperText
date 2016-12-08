//
//  Book.swift
//  HyperText
//
//  Created by David Parker on 11/7/16.
//  Copyright © 2016 Group 14. All rights reserved.
//

import Foundation
import UIKit

class Book {
    var title:String
    var content:String
    var cover:UIImage
    var index:Int
    
    init(let title:String, let content:String, let cover:UIImage, let index:Int) {
        self.title = title
        self.content = content
        self.cover = cover
        self.index = index
    }
}
