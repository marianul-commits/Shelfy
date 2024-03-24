//
//  TestView.swift
//  Shelfy
//
//  Created by Marian Nasturica on 11.07.2023.
//

import UIKit
import CoreData
import NotificationBannerSwift
import SkeletonView
import Cosmos


class TestView: UIViewController {
    
    lazy var imageView = UIImageView()
    lazy var randomBook = ""
    lazy var coverID = ""
    var hotContainer = UIView()
    lazy var bookTitle = UILabel()
    lazy var header = UILabel()
    lazy var bookAuthor = UILabel()
    lazy var errorLbl = UILabel()
//    var collectionView = UICollectionView()
    var trendingNowLbl = makeLabel(withText: "Trending Now")


    
    let categories = ["Home", "Tech", "Science", "Health", "Sport", "Pastime", "Business"]

    var selectedButtonIndex: Int = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        /*
         
         create collection view (mosaic if possible) with book genres
         default category = random int between 0..< X -> X = total book genres
         make it update the search
         
         contrary
         make it open BookView
         
         */
        
        pickRandomBook(fromGenre: "\(selectedButtonIndex)") { title, coverID, authorName in
            if let title = title, let coverID = coverID {
                self.randomBook = title
                self.coverID = coverID
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.bookTitle.text = title
                    self.bookAuthor.text = "By \(authorName!)"
                    downloadCoverImage(coverImageID: "\(coverID)", targetImageView: self.imageView, placeholderImage: UIImage(resource: .placeholder))
                    UIView.animate(withDuration: 1.5, delay: 0.5, options: [.curveEaseIn], animations: {
                        self.imageView.alpha = 1.0
                        self.bookTitle.alpha = 1.0
                        self.header.alpha = 1.0
                        self.bookAuthor.alpha = 1.0
                    }, completion: nil)
                }
            } else {
                print("Failed to fetch a random book")
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseIn], animations: {
                        self.errorLbl.alpha = 1.0
                        self.header.alpha = 0.0
                    }, completion: nil)
                    if self.bookTitle.text == nil && self.bookAuthor.text == nil || ((self.bookAuthor.text?.isEmpty) != nil) {
                        self.errorLbl.text = K.errorLbl
                    }
                }
            }
        }
    }

    
    
}


