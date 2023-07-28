//
//  BookView.swift
//  Shelfy
//
//  Created by Marian Nasturica on 11.06.2023.
//

import UIKit
import Cosmos

class BookView: UIViewController {
    
    
    @IBOutlet weak var bookImg: UIImageView!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookAuth: UILabel!
    @IBOutlet weak var moreByView: UIView!
    @IBOutlet weak var descrView: UIView!
    @IBOutlet weak var descrLbl: UILabel!
    @IBOutlet weak var descrScrollView: UIScrollView!
    @IBOutlet weak var moreCollection: UICollectionView!
    @IBOutlet weak var bookDescr: UILabel!
    
    var bTitle: String?
    var author: String?
    var bImage: String?
    var descr: String?
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let contentOffset = descrScrollView.contentOffset
        
//        moreCollection.dataSource = self
//        moreCollection.delegate = self
        
        descrScrollView.setContentOffset(contentOffset, animated: false)
                
        bookTitle.text = bTitle
        bookAuth.text = author
        bookDescr.text = descr
        
        if let imageURLString = bImage,
           let imageURL = URL(string: imageURLString) {
            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: imageURL),
                   let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        self.bookImg.image = image
                    }
                }
            }
        } else {
            // If the book has no photo, set a placeholder image
            bookImg.image = UIImage(named: "placeholder")
        }
        descrView.layer.cornerRadius = descrView.frame.size.height / 25
        moreByView.layer.cornerRadius = moreByView.frame.size.height / 25
        
    }
    
}

//extension BookView: UICollectionViewDataSource, UICollectionViewDelegate {
//
//    // Number of items in the collection view
//    func collectionView(_ moreCollection: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 5 // Return the number of items you want to display
//    }
//
//    // Configure the cells
//    func collectionView(_ moreCollection: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = moreCollection.dequeueReusableCell(withReuseIdentifier: "moreByAuthor", for: indexPath) as! CollectionViewCell
//        // Customize the cell's content based on the data you have
//        cell.titleLbl.text = "Item \(indexPath.item)"
//        return cell
//    }
//}
