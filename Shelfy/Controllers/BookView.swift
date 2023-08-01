//
//  BookView.swift
//  Shelfy
//
//  Created by Marian Nasturica on 11.06.2023.
//

import UIKit
import Cosmos

class BookView: UIViewController {
    
    
    @IBOutlet weak var wantToBuyBtn: UIButton!
    @IBOutlet weak var addToShelfyBtn: UIButton!
    @IBOutlet weak var readBtn: UIButton!
    @IBOutlet weak var moreViewLbl: UILabel!
    @IBOutlet weak var buttonStack: UIStackView!
    @IBOutlet weak var bookDetailStack: UIStackView!
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
        //        let bookOffset = bookScrollView.contentOffset
        //MARK: Collection View
        //        moreCollection.dataSource = self
        //        moreCollection.delegate = self
        moreCollection.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "moreByAuthor")
        if let layout = moreCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        moreCollection.backgroundColor = .clear
        //MARK: Scroll View
        descrScrollView.setContentOffset(contentOffset, animated: false)
        descrScrollView.showsHorizontalScrollIndicator = false
        descrScrollView.isDirectionalLockEnabled = true
        scrollViewDidScroll(descrScrollView)
        descrScrollView.contentSize = CGSize(width: descrView.frame.width, height: descrView.frame.width + 100)
        //        bookScrollView.setContentOffset(bookOffset, animated: false)
        //        let screenWidth = UIScreen.main.bounds.width
        //        let screenHeight = UIScreen.main.bounds.height
        //        let contentWidth = screenWidth
        //        let contentHeight = screenHeight * 2
        //        bookScrollView.contentSize = CGSize(width: contentWidth, height: contentHeight)
        //        bookScrollView.addSubview(descrView)
        //        bookScrollView.addSubview(moreByView)
        //MARK: Table View
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
        bookImg.contentMode = .scaleAspectFit
        
        // Constaints
        
        bookDescr.lineBreakMode = .byWordWrapping
        bookDescr.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 751), for: .vertical)
        bookDetailStack.spacing = 5
        bookDetailStack.alignment = .center
        bookDetailStack.distribution = .fill
        bookDetailStack.axis = .vertical
        buttonStack.spacing = 4
        buttonStack.alignment = .center
        buttonStack.distribution = .fillProportionally
        buttonStack.axis = .horizontal
//        addToShelfyBtn.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
//        wantToBuyBtn.setContentHuggingPriority(UILayoutPriority(rawValue: 249), for: .horizontal)
        addToShelfyBtn.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 751), for: .horizontal)
        wantToBuyBtn.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 749), for: .horizontal)
//        wantToBuyBtn.titleLabel!.adjustsFontSizeToFitWidth = true
        addToShelfyBtn.titleLabel!.adjustsFontSizeToFitWidth = true
        addToShelfyBtn.titleLabel!.numberOfLines = 1
        
        
        NSLayoutConstraint.activate([
            bookImg.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            bookImg.heightAnchor.constraint(equalToConstant: 220),
            bookImg.widthAnchor.constraint(equalToConstant: 150),
            bookImg.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bookDetailStack.centerXAnchor.constraint(equalTo: bookImg.centerXAnchor),
            bookDetailStack.topAnchor.constraint(equalTo: bookImg.bottomAnchor, constant: 8),
            buttonStack.topAnchor.constraint(equalTo: bookDetailStack.bottomAnchor, constant: 15),
            buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            descrView.topAnchor.constraint(equalTo: buttonStack.bottomAnchor, constant: 15),
            descrView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            descrView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10),
            descrLbl.leadingAnchor.constraint(equalTo: descrView.leadingAnchor, constant: 10),
            descrLbl.topAnchor.constraint(equalTo: descrView.topAnchor, constant: 8),
            descrScrollView.topAnchor.constraint(equalTo: descrLbl.bottomAnchor, constant: 8),
            descrScrollView.bottomAnchor.constraint(equalTo: descrView.bottomAnchor, constant: -20),
            descrScrollView.centerXAnchor.constraint(equalTo: descrView.centerXAnchor),
            descrScrollView.leadingAnchor.constraint(equalTo: descrView.leadingAnchor),
            descrScrollView.trailingAnchor.constraint(equalTo: descrView.trailingAnchor),
            bookDescr.leadingAnchor.constraint(equalTo: descrView.leadingAnchor, constant: 20),
            bookDescr.trailingAnchor.constraint(equalTo: descrView.trailingAnchor, constant: -20),
            bookDescr.topAnchor.constraint(equalTo: descrScrollView.topAnchor, constant: 5),
            bookDescr.bottomAnchor.constraint(equalTo: descrScrollView.bottomAnchor),
            moreByView.topAnchor.constraint(equalTo: descrView.bottomAnchor, constant: 15),
            moreByView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            moreByView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            moreViewLbl.topAnchor.constraint(equalTo: moreByView.topAnchor, constant: 8),
            moreViewLbl.leadingAnchor.constraint(equalTo: moreByView.leadingAnchor, constant: 10),
            moreCollection.topAnchor.constraint(equalTo: moreViewLbl.bottomAnchor, constant: 10),
            moreCollection.leadingAnchor.constraint(equalTo: moreByView.leadingAnchor),
            moreCollection.trailingAnchor.constraint(equalTo: moreByView.trailingAnchor)
        ])
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x > 0 {
            scrollView.contentOffset.x = 0
        }
        if scrollView.contentOffset.x < 0 {
            scrollView.contentOffset.x = 0
        }
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
