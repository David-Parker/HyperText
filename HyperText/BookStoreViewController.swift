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
    let books:[String] = ["Huckleberry Fin", "Ulysses", "Alice in Wonderland", "Dracula", "Welcome", "A Christmas Carol", "Tom Sawyer", "Moby Dick"]
    
    var client:Client? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        client = Client.getLoggedInUser()
        
        let storageRef = FIRStorage.storage().reference()
        
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
                                let dataString = String(data: data!, encoding: NSUTF8StringEncoding)

                                let bk:Book = Book(title: book, content: dataString!, cover: decodedImage!, index: 0)
                                self.items.append(bk)
                                count = count + 1
                                
                                // Final book
                                if(count == self.books.count) {
                                    for book in self.items {
                                        print("books title in book store \(book.title)")
                                    }
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
        var userBooks:[String] = [String]()
        
        for book in self.client!.books {
            userBooks.append(book.title)
        }
        
        let storageRef = FIRStorage.storage().reference()
        let book:String = self.items[indexPath.item].title
        print("books name when downloading \(book)")
        let path:String = "Books/\(book).txt"
        let coverPath:String = "Covers/\(book)-cover.png"
        let bookRef = storageRef.child(path)
        let coverRef = storageRef.child(coverPath)
            
        // Maximum book size is 1Mb, unless the size is increased here
        bookRef.dataWithMaxSize(1 * 1024 * 1024) { (data, error) -> Void in
            coverRef.dataWithMaxSize(1 * 1024 * 1024) { (data2, error2) -> Void in
                if (error2 != nil) {
                    print("books error")
                    // Uh-oh, an error occurred!
                }
                else {
                    if (error != nil) {
                        print("books error2")
                        // Uh-oh, an error occurred!
                    }
                    else if(userBooks.contains(book)) {
                        let alert = UIAlertController(title: "", message: "You already downloaded this book.", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                    else {
                        userBooks.append(book)
                        self.client!.books.append(self.items[indexPath.item])
    
                        let ref = FIRDatabase.database().reference()
                        let userID = FIRAuth.auth()?.currentUser?.uid
                        ref.child("books").child(userID!).setValue(["books": userBooks])
                        
                        Client.getLoggedInUser()?.loadUsersBooks((FIRAuth.auth()?.currentUser?.uid)!,
                            success: { () -> Void in
                                let segue:LibraryController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("library-tab") as! LibraryController
                                                                    
                                let navController = UINavigationController(rootViewController: segue)
                                                                    
                                self.presentViewController(navController, animated: true, completion: nil)
                            },
                            err: { () -> Void in
                                let alertController = UIAlertController(title: "Error", message: "There was an error loading your library..", preferredStyle: UIAlertControllerStyle.Alert)
                                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
                                    print("OK")
                                }
                                alertController.addAction(okAction)
                                self.presentViewController(alertController, animated: true, completion: nil)
                                return
                        })
                    }
                }
            }
        }
    }
}
