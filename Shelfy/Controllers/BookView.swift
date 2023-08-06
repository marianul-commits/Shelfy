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
    @IBOutlet weak var bookScrollView: UIScrollView!
    @IBOutlet weak var descrLbl: UILabel!
    @IBOutlet weak var descrScrollView: UIScrollView!
    @IBOutlet weak var bookDescr: UILabel!
    
    let moreCollection : UICollectionView = {
        let layout = CustomFlowLayout()
        let moreCollection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        moreCollection.translatesAutoresizingMaskIntoConstraints = false
        moreCollection.backgroundColor = .clear
        moreCollection.showsVerticalScrollIndicator = false
        return moreCollection
    }()
    
    var bTitle: String?
    var author: String?
    var bImage: String?
    var descr: String?
    var moreAuthors = [Items]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        fetchAuthor(author!) { (moreAuthors) in
            guard let moreAuthors = moreAuthors else {
                print("Error fetching books")
                return
            }
            
            DispatchQueue.main.async {
                self.moreAuthors = moreAuthors
                self.moreCollection.reloadData()
            }
        }
        
        
        let contentOffset = descrScrollView.contentOffset
        //MARK: Collection View
        moreCollection.dataSource = self
        moreCollection.delegate = self
        moreCollection.register(MoreByCell.self, forCellWithReuseIdentifier: "testIdentifier")
//        if let layout = moreCollection.collectionViewLayout as? UICollectionViewFlowLayout {
//            layout.scrollDirection = .horizontal
//        }
//        moreCollection.backgroundColor = .clear
        //MARK: Scroll View
        descrScrollView.setContentOffset(contentOffset, animated: false)
        descrScrollView.showsHorizontalScrollIndicator = false
        descrScrollView.isDirectionalLockEnabled = true
        scrollViewDidScroll(descrScrollView)
        
        bookScrollView.setContentOffset(contentOffset, animated: false)
        bookScrollView.showsHorizontalScrollIndicator = false
        bookScrollView.isDirectionalLockEnabled = true
        scrollViewDidScroll(bookScrollView)
        
//        bookScrollView.contentSize = CGSize(width: view.frame.width, height: descrView.frame.height + moreByView.frame.height)
        
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
        moreByView.addSubview(moreCollection)
        bookImg.contentMode = .scaleAspectFit
        
        let spacerView = UILayoutGuide()
        bookScrollView.addLayoutGuide(spacerView)
        
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
        bookScrollView.addSubview(descrView)
        bookScrollView.addSubview(moreByView)
        
        bookScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            //Book Image Constraints
            bookImg.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            bookImg.heightAnchor.constraint(equalToConstant: 220),
            bookImg.widthAnchor.constraint(equalToConstant: 150),
            bookImg.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            //Book Name Constraints
            bookDetailStack.centerXAnchor.constraint(equalTo: bookImg.centerXAnchor),
            bookDetailStack.topAnchor.constraint(equalTo: bookImg.bottomAnchor, constant: 8),
            //Button Constraints
            buttonStack.topAnchor.constraint(equalTo: bookDetailStack.bottomAnchor, constant: 15),
            buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            //Book Scroll View Constraints
            bookScrollView.topAnchor.constraint(equalTo: buttonStack.bottomAnchor, constant: 15),
            bookScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            bookScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            bookScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            //Description View Constraints
            descrView.topAnchor.constraint(equalTo: bookScrollView.topAnchor, constant: 15),
            descrView.leadingAnchor.constraint(equalTo: bookScrollView.leadingAnchor, constant: 5),
            descrView.trailingAnchor.constraint(equalTo: bookScrollView.trailingAnchor, constant: -5),
            descrView.heightAnchor.constraint(equalToConstant: 240),
            descrView.bottomAnchor.constraint(equalTo: spacerView.topAnchor, constant: 15),
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
            // Spacer View Constraints
            spacerView.topAnchor.constraint(equalTo: descrView.bottomAnchor, constant: 15),
            spacerView.leadingAnchor.constraint(equalTo: bookScrollView.leadingAnchor),
            spacerView.trailingAnchor.constraint(equalTo: bookScrollView.trailingAnchor),
            spacerView.heightAnchor.constraint(equalToConstant: 20), // Adjust the constant to create the desired spacing
            //More By Constraints
            moreByView.topAnchor.constraint(equalTo: spacerView.bottomAnchor),
            moreByView.leadingAnchor.constraint(equalTo: bookScrollView.leadingAnchor, constant: 5),
            moreByView.trailingAnchor.constraint(equalTo: bookScrollView.trailingAnchor, constant: -5),
            moreByView.bottomAnchor.constraint(equalTo: bookScrollView.bottomAnchor, constant: -5),
            moreViewLbl.topAnchor.constraint(equalTo: moreByView.topAnchor, constant: 8),
            moreViewLbl.leadingAnchor.constraint(equalTo: moreByView.leadingAnchor, constant: 10),
            moreCollection.topAnchor.constraint(equalTo: moreViewLbl.bottomAnchor, constant: 10),
            moreCollection.leadingAnchor.constraint(equalTo: moreByView.leadingAnchor),
            moreCollection.trailingAnchor.constraint(equalTo: moreByView.trailingAnchor),
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

extension BookView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moreAuthors.count
    }
    
    // Configure the cells
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "testIdentifier", for: indexPath) as! MoreByCell
        // Customize the cell's content based on the data you have
        cell.titleLabel?.text = moreAuthors[indexPath.row].volumeInfo.title
        
        if let imageURLString = moreAuthors[indexPath.row].volumeInfo.imageLinks?.thumbnail,
           let imageURL = URL(string: imageURLString) {
            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: imageURL),
                   let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        cell.imageView.image = image
                    }
                }
            }
        } else {
            // If the book has no photo, set a placeholder image
            cell.imageView.image = UIImage(named: "placeholder")
        }
        
        return cell
    }

}
