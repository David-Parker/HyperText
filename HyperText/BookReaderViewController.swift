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
    var isPaused:Bool = true
    var speedReading = Client.getSettingsForAccount().speedReading
    var words:[String] = []
    var wordsIndex = 0
    var interval:Float = 0
    var speedReadTimer:NSTimer = NSTimer()
    
    @IBOutlet weak var mark2: UILabel!
    @IBOutlet weak var mark1: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var bookmarkLabel: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var resetButtonLabel: UILabel!
    
    @IBAction func backPressed(sender: AnyObject) {
        if self.wordsIndex > 1 {
            self.wordsIndex -= 2
            pauseTimer()
            speedRead()
        }
    }
    @IBAction func forwardPressed(sender: AnyObject) {
        print("OH OK")
        if self.wordsIndex < words.count {
            print("oh hello")
            pauseTimer()
            speedRead()
        }
    }
    @IBAction func pausePressed(sender: AnyObject) {
        if (isPaused) {
            startTimer()
        }
        else {
            pauseTimer()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(book == nil) {
            print("Error in BookReaderViewController, book was nil!")
            return
        }
        
        if(speedReading) {
            self.wordsIndex = (book?.index)!
            self.pauseButton.hidden = false
            self.textField.hidden = true
            
            self.mark1.hidden = false
            self.mark2.hidden = false
            
            self.backButton.hidden = false
            self.forwardButton.hidden = false
            
            self.bookmarkButton.hidden = false
            self.bookmarkLabel.hidden = false
            
            self.resetButton.hidden = false
            self.resetButtonLabel.hidden = false
            
            self.interval = Client.getSettingsForAccount().speed
            self.label.hidden = false
            self.words = book!.content.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        }
        else {
            self.textField.hidden = false
            self.label.hidden = true
            self.pauseButton.hidden = true
            
            self.mark1.hidden = true
            self.mark2.hidden = true
            
            self.bookmarkButton.hidden = true
            self.bookmarkLabel.hidden = true
            
            self.resetButton.hidden = true
            self.resetButtonLabel.hidden = true
            
            self.title="\(book!.title)"
            self.textField.text = book!.content
            
            self.backButton.hidden = true
            self.forwardButton.hidden = true
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if(book?.index != nil) {
            self.wordsIndex = (book?.index)!
        }
        else {
            self.wordsIndex = 0
        }
    }
    
    func pauseTimer() {
        speedReadTimer.invalidate()
        speedReadTimer = NSTimer()
        
        pauseButton.setTitle("Resume", forState: .Normal)
        isPaused = true
    }
    
    func startTimer() {
        speedReadTimer = NSTimer.scheduledTimerWithTimeInterval(0.1/Double(interval), target: self, selector: #selector(speedRead), userInfo: nil, repeats: true)
        pauseButton.setTitle("Pause", forState: .Normal)
        isPaused = false
    }
    
    func speedRead() {
        if (words.count <= wordsIndex) {
            pauseTimer()
            return
        }
        
        let black = [NSForegroundColorAttributeName: UIColor.blackColor()]
        let red = [NSForegroundColorAttributeName: UIColor.redColor()]
        let word = words[wordsIndex].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        if (word.characters.count == 0) {
            self.wordsIndex += 1
            return
        }
        
        let middleLetter:Int = center(word)
        
        var one = word[word.startIndex..<word.startIndex.advancedBy(middleLetter)]
        let two = String(word[word.startIndex.advancedBy(middleLetter)])
        let three = word[word.startIndex.advancedBy(middleLetter+1)..<word.endIndex]
        
        one = "".stringByPaddingToLength(4-one.characters.count, withString: " ", startingAtIndex: 0) + one
        
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
    
    func center(word:String) -> Int {
        let wordLength = word.characters.count;
        var pivot = (wordLength + 2) / 4;
        
        if (pivot > 4) {
            pivot = 4;
        }
        
        if (String(word[word.startIndex.advancedBy(pivot)]) == " ") {
            pivot -= 1;
        }
        
        return pivot;
    }
    
    @IBAction func bookmarkButtonPressed(sender: AnyObject) {
        Client.setBookmark(book, index: wordsIndex)
        book?.index = wordsIndex
    }
    
    @IBAction func resetButtonPressed(sender: AnyObject) {
        wordsIndex = 0
        Client.setBookmark(book, index: wordsIndex)
        book?.index = wordsIndex
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
