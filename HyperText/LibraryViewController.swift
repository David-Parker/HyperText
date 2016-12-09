//
//  LibraryViewController.swift
//  HyperText
//
//  Created by David Parker on 10/21/16.
//  Copyright © 2016 Group 14. All rights reserved.
//

import UIKit

class LibraryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var booksCollection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let reuseIdentifier = "cell"
    var items:[Book] = [Book]()
    var filtered:[Book] = [Book]()

    var client:Client? = nil
    
    var searchActive = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadBooks()
        searchBar.delegate = self
        
        self.title = "\(client!.firstName) \(client!.lastName)'s Library"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if(searchActive) {
            return self.filtered.count
        }
        else {
           return self.items.count 
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! BooksCollectionViewCell
        
        if(searchActive) {
            cell.title.text! = filtered[indexPath.item].title
            cell.cover.image = filtered[indexPath.item].cover
        }
        else {
            cell.title.text! = items[indexPath.item].title
            cell.cover.image = items[indexPath.item].cover
        }

        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // handle tap events
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let viewController: BookReaderViewController = segue.destinationViewController as? BookReaderViewController {
            let cell = sender as! BooksCollectionViewCell
            
            let book = items[self.booksCollection.indexPathForCell(cell)!.item]
            
            viewController.title = "Book Reader"
            viewController.book = book
        }
    }
    
    func loadBooks() {
        self.items.removeAll()
        
        client = Client.getLoggedInUser()
        
        if(client == nil) {
            print("Error in LibraryViewController, no client exists")
            return
        }
        
        for book in client!.books {
            items.append(book)
        }
        
        items.sortInPlace({$0.title < $1.title})
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false
        searchBar.text = ""
        booksCollection.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filtered = items.filter({ (book) -> Bool in
            let tmp:NSString = book.title
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
            
        })
        
        searchActive = true
        
        if(searchBar.text == "") {
            searchActive = false
        }
        
        booksCollection.reloadData()
    }
}
