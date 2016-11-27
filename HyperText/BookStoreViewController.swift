//
//  BookStoreViewController.swift
//  HyperText
//
//  Created by Katherine Bruton on 11/26/16.
//  Copyright © 2016 Group 14. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class BookStoreViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var booksCollection: UICollectionView!
    
    let reuseIdentifier = "cell"
    var items:[Book] = [Book]()
    
    var client:Client? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        client = Client.getLoggedInUser()
        
        
        let storageRef = FIRStorage.storage().reference()
        
        let books:[String] = ["Huckleberry Fin", "Ulysses", "Alice in Wonderland", "Dracula", "Welcome"]
        var count:Int = 0
        
        if(items.count == 0) {
            for book in books {
                let path:String = "Books/\(book).txt"
                let coverPath:String = "Covers/\(book)-cover.png"
                let bookRef = storageRef.child(path)
                let coverRef = storageRef.child(coverPath)
                
                // Maximum book size is 1Mb, unless the size is increased here
                bookRef.dataWithMaxSize(1 * 1024 * 1024) { (data, error) -> Void in
                    coverRef.dataWithMaxSize(1 * 1024 * 1024) { (data2, error2) -> Void in
                        if (error2 != nil) {
                            // Uh-oh, an error occurred!
                            print("books error")
                        }
                        else {
                            if (error != nil) {
                                // Uh-oh, an error occurred!
                                print("books error")
                            }
                            else {
                                let decodedImage:UIImage! = UIImage(data: data2!)
                                
                                let bk:Book = Book(title: book, content: "", cover: decodedImage!)
                                self.items.append(bk)
                                count = count + 1
                                
                                // Final book
                                if(count == books.count) {
                                    self.booksCollection.reloadData()
                                }
                            }
                        }
                    }
                }
            }
        }
        
        items.sortInPlace({$0.title < $1.title})
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! BooksCollectionViewCell
        cell.title.text! = items[indexPath.item].title
        cell.cover.image = items[indexPath.item].cover
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // handle tap events
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
