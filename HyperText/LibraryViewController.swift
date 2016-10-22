//
//  LibraryViewController.swift
//  HyperText
//
//  Created by David Parker on 10/21/16.
//  Copyright © 2016 Group 14. All rights reserved.
//

import UIKit

class LibraryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var booksCollection: UICollectionView!
    
    let reuseIdentifier = "cell"
    var items:[String] = [String]()

    var client:Client? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create 50 dummy books
        for i in 1...50 {
            items.append("\(i)")
        }
        
        client = Client.getLoggedInUser()
        
        if(client == nil) {
            print("Error in LibraryViewContrller, no client exists")
            return
        }

        titleLabel.text = "\(client!.firstName) \(client!.lastName)'s Library"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! BooksCollectionViewCell
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // handle tap events
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let viewController: BookReaderViewController = segue.destinationViewController as? BookReaderViewController {
            let cell = sender as! BooksCollectionViewCell
            
            let item = items[self.booksCollection.indexPathForCell(cell)!.item]
            viewController.title = "Book Reader"
            viewController.book = "Book \(item)"
        }
    }
}
