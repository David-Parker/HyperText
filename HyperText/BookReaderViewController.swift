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
    @IBOutlet weak var label: UILabel!
    
    var book:Book? = nil
    
    var speedReading = Client.getSettingsForAccount().speedReading
    
    var words:[String] = []
    var wordsIndex = 0
    
    var interval:Float = 0
    
    @IBOutlet weak var pauseButton: UIButton!
    
    @IBAction func pausePressed(sender: AnyObject) {
        if isPaused {
            startTimer()

        } else {
            pauseTimer()

            
        }
    }
    var speedReadTimer:NSTimer = NSTimer()
    
    var isPaused:Bool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        if(!speedReading && book != nil) {
            self.textField.hidden = false
            self.label.hidden = true
            self.pauseButton.hidden = true
            
            self.mark1.hidden = true
            self.mark2.hidden = true
            
            self.title="\(book!.title)"
            self.textField.text = book!.content
        } else {
            self.pauseButton.hidden = false
            self.textField.hidden = true
            
            self.mark1.hidden = false
            self.mark2.hidden = false
            
            self.interval = Client.getSettingsForAccount().speed
            
            self.label.hidden = false
            
            self.words = book!.content.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            print(words)
//            speedReadTimer = NSTimer.scheduledTimerWithTimeInterval(0.25, target: self, selector: Selector("speedRead"), userInfo: nil, repeats: true)
            

            
            
            
            
            
        }
        

        
        
    }
    
    func pauseTimer() {
        speedReadTimer.invalidate()
        speedReadTimer = NSTimer()
        
        pauseButton.setTitle("Resume", forState: .Normal)
        isPaused = true
    }
    
    @IBOutlet weak var mark2: UILabel!
    @IBOutlet weak var mark1: UILabel!
    func startTimer() {
        speedReadTimer = NSTimer.scheduledTimerWithTimeInterval(0.1/Double(interval), target: self, selector: #selector(speedRead), userInfo: nil, repeats: true)
        pauseButton.setTitle("Pause", forState: .Normal)
        isPaused = false
    }
    
    func speedRead() {
        if words.count <= wordsIndex {
            pauseTimer()
            return
        }
        
        let black = [NSForegroundColorAttributeName: UIColor.blackColor()]
        let red = [NSForegroundColorAttributeName: UIColor.redColor()]
        
        let word = words[wordsIndex].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
//        print("#"+word+"#")
        
        if word.characters.count == 0 {
            self.wordsIndex += 1
            return
        }
        
        let middleLetter:Int = center(word)
        
        var one = word[word.startIndex..<word.startIndex.advancedBy(middleLetter)]
        let two = String(word[word.startIndex.advancedBy(middleLetter)])
        let three = word[word.startIndex.advancedBy(middleLetter+1)..<word.endIndex]
        
//        print("#"+one+"#")
//        print("#"+two+"#")
//        print("#"+three+"#")
        
        
            one = "".stringByPaddingToLength(4-one.characters.count,
                                          withString: " ",
                                          startingAtIndex: 0) + one
        
        let partOne = NSMutableAttributedString(string: one, attributes: black)
        let partTwo = NSMutableAttributedString(string: two, attributes: red)
        let partThree = NSMutableAttributedString(string: three, attributes: black)
        
        let combination = NSMutableAttributedString()
        
        combination.appendAttributedString(partOne)
        combination.appendAttributedString(partTwo)
        combination.appendAttributedString(partThree)
        

        
        self.label.attributedText = combination
        
        self.wordsIndex += 1
    }
    
    func center(word:String)->Int {
        let wordLength = word.characters.count;
        var pivot = (wordLength + 2) / 4;
        
        if pivot > 4 {
            pivot = 4;
        }
        
        if String(word[word.startIndex.advancedBy(pivot)]) == " " {
            pivot -= 1;
        }
        return pivot;

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
