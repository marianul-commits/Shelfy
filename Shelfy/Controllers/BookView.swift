//
//  BookView.swift
//  Shelfy
//
//  Created by Marian Nasturica on 11.06.2023.
//

import UIKit
import Cosmos

class BookView: UIViewController {
    
    let bookImg = makeImgView(withImage: "placeholder")
    let bookTitle = makeLabel(withText: "Title")
    let bookAuthor = makeLabel(withText: "Author")
    let buyBtn = makeButton(withTitle: "Share")
    let readBtn = makeButton(withTitle: "Did Read")
    let shelfyBtn = makeButton(withTitle: "Add to Shelfy")
    let btnStack = makeStackView(withOrientation: .horizontal)
    let descrHeader = makeLabel(withText: "Description")
    let moreByHeader = makeLabel(withText: "More By Author")
    let descrContent = makeLabel(withText: "")
    let moreCollection = makeCollectionView()
    let stackView = makeStackView(withOrientation: .vertical)
    let topView = TopView()
    let bottomView = BottomView()
    
    var bTitle: String?
    var author: String?
    var bImage: String?
    var descr: String?
    var moreAuthors = [Items]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //MARK: API Call
//        fetchAuthor(author!) { (moreAuthors) in
//            guard let moreAuthors = moreAuthors else {
//                print("Error fetching books")
//                return
//            }
//
//            DispatchQueue.main.async {
//                self.moreAuthors = moreAuthors
//                self.moreCollection.reloadData()
//            }
//        }
        
        //MARK: Collection View
        moreCollection.dataSource = self
        moreCollection.delegate = self
        moreCollection.register(MoreByCell.self, forCellWithReuseIdentifier: "testIdentifier")
        //        if let layout = moreCollection.collectionViewLayout as? UICollectionViewFlowLayout {
        //            layout.scrollDirection = .horizontal
        //        }
        //        moreCollection.backgroundColor = .clear
        //MARK: Book Details
        bookTitle.text = bTitle
        bookAuthor.text = author
        descrContent.text = descr
        
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
        
        
        setupBookView()
        view.backgroundColor = UIColor(named: "Background")
        
        bottomView.layer.cornerRadius = bottomView.frame.size.height / 25
    }
    
    func setupBookView() {
        
        bookImg.contentMode = .scaleAspectFit
        
        //Text Customization
        bookTitle.font = SetFont.setFontStyle(.regular, 16)
        bookTitle.textColor = .label
        bookAuthor.font = SetFont.setFontStyle(.light, 14)
        bookAuthor.textColor = .label
        descrHeader.font = SetFont.setFontStyle(.medium, 16)
        descrHeader.textColor = UIColor(named: "Color1")
        descrContent.font = SetFont.setFontStyle(.regular, 14)
        bookAuthor.textColor = .label
        moreByHeader.font = SetFont.setFontStyle(.medium, 16)
        bookAuthor.textColor = UIColor(named: "Color1")
        
        //Book Scroll View
        let screenBound = UIScreen.main.bounds

        let bookSV = UIScrollView(frame: CGRect(x: 0, y: 0, width: bottomView.bounds.width, height: bottomView.bounds.height))
        bookSV.translatesAutoresizingMaskIntoConstraints = false
        bookSV.contentSize = CGSize(width: screenBound.width * 2, height: screenBound.height / 2)
        bookSV.isPagingEnabled = true
        bookSV.alwaysBounceVertical = false
        disableVerticalScroll(bookSV)
        
        let descrView = UIView(frame: CGRect(x: 0, y: 0, width: bottomView.bounds.width, height: bottomView.bounds.height))
        descrView.backgroundColor = UIColor(named: "Accent9")
        
        let moreByView = UIView(frame: CGRect(x: bottomView.bounds.width, y: 0, width: bottomView.bounds.width, height: bottomView.bounds.height))
        moreByView.backgroundColor = UIColor(named: "Accent9")
        
        //Description Scroll View
        let descrScroll = UIScrollView(frame: CGRect(x: 20, y: 10, width: descrView.bounds.width, height: descrContent.bounds.height))
        descrScroll.translatesAutoresizingMaskIntoConstraints = false
        descrScroll.contentSize = CGSize(width: descrView.bounds.width, height: descrContent.bounds.height)
        bookSV.alwaysBounceHorizontal = false
        disableHorizontalScroll(descrScroll)
        
        stackView.addArrangedSubview(topView)
        stackView.addArrangedSubview(bottomView)
        
        topView.addSubview(bookImg)
        topView.addSubview(bookTitle)
        topView.addSubview(bookAuthor)
        topView.addSubview(btnStack)
        
        btnStack.addArrangedSubview(shelfyBtn)
        btnStack.addArrangedSubview(readBtn)
        btnStack.addArrangedSubview(buyBtn)
        
        bottomView.addSubview(bookSV)
        
        bookSV.addSubview(descrView)
        descrView.addSubview(descrHeader)
        descrView.addSubview(descrContent)
        bookSV.addSubview(moreByView)
        moreByView.addSubview(moreByHeader)
//        moreByView.addSubview(moreCollection)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            
            //MARK: Top View Constraints
            
            bookImg.topAnchor.constraint(equalTo: topView.safeAreaLayoutGuide.topAnchor, constant: 10),
            bookImg.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            bookImg.widthAnchor.constraint(equalToConstant: 141),
            bookImg.heightAnchor.constraint(equalToConstant: 225),
            
            bookTitle.topAnchor.constraint(equalTo: bookImg.bottomAnchor, constant: 10),
            bookAuthor.topAnchor.constraint(equalTo: bookTitle.bottomAnchor, constant: 5),
            bookTitle.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            bookAuthor.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            
            btnStack.topAnchor.constraint(equalTo: bookAuthor.bottomAnchor, constant: 10),
            btnStack.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            btnStack.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -5),
            btnStack.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 5),
            
            topView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            topView.widthAnchor.constraint(equalTo: view.widthAnchor),
            bottomView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            bottomView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            //MARK: Bottom View Constraints
            
//            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
//            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            bookSV.topAnchor.constraint(equalTo: bottomView.topAnchor),
            bookSV.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor),
            bookSV.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor),
            bookSV.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor),
            
            //Description View Constraints
            
            descrView.topAnchor.constraint(equalTo: bookSV.topAnchor),
            descrView.leadingAnchor.constraint(equalTo: bookSV.leadingAnchor),
            descrView.trailingAnchor.constraint(equalTo: bookSV.trailingAnchor),
            descrView.bottomAnchor.constraint(equalTo: bookSV.bottomAnchor),
            
            descrHeader.topAnchor.constraint(equalTo: descrView.topAnchor, constant: 5),
            descrHeader.leadingAnchor.constraint(equalTo: descrView.leadingAnchor, constant: 5),
            
//            descrScroll.topAnchor.constraint(equalTo: descrView.topAnchor),
//            descrScroll.leadingAnchor.constraint(equalTo: descrView.leadingAnchor),
//            descrScroll.trailingAnchor.constraint(equalTo: descrView.trailingAnchor),
//            descrScroll.bottomAnchor.constraint(equalTo: descrView.bottomAnchor),
            
            descrContent.topAnchor.constraint(equalTo: descrView.topAnchor, constant: 15),
            descrContent.leadingAnchor.constraint(equalTo: descrView.leadingAnchor,constant: 5),
            descrContent.trailingAnchor.constraint(equalTo: descrView.trailingAnchor, constant: -5),
            descrContent.bottomAnchor.constraint(equalTo: descrView.bottomAnchor),
            
            //More View
            
            moreByView.topAnchor.constraint(equalTo: bookSV.topAnchor),
            moreByView.leadingAnchor.constraint(equalTo: bookSV.leadingAnchor),
            moreByView.trailingAnchor.constraint(equalTo: bookSV.trailingAnchor),
            moreByView.bottomAnchor.constraint(equalTo: bookSV.bottomAnchor),
            
            moreByHeader.topAnchor.constraint(equalTo: moreByView.topAnchor, constant: 5),
            moreByHeader.leadingAnchor.constraint(equalTo: moreByView.leadingAnchor, constant: 5),
            
//            moreCollection.topAnchor.constraint(equalTo: moreByHeader.bottomAnchor, constant: 5),
//            moreCollection.leadingAnchor.constraint(equalTo: moreByView.leadingAnchor, constant: 5),
//            moreCollection.trailingAnchor.constraint(equalTo: moreByView.trailingAnchor, constant: -5),
//            moreCollection.bottomAnchor.constraint(equalTo: moreByView.bottomAnchor),


            
        ])
    }
    
    func disableHorizontalScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x > 0 {
            scrollView.contentOffset.x = 0
        }
        if scrollView.contentOffset.x < 0 {
            scrollView.contentOffset.x = 0
        }
    }
    
    func disableVerticalScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 {
            scrollView.contentOffset.y = 0
        }
        if scrollView.contentOffset.y < 0 {
            scrollView.contentOffset.y = 0
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
