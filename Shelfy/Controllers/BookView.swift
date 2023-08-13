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
    let moreByHeader = makeLabel(withText: "More like this")
    let descrContent = makeLabel(withText: "")
    let moreCollection = makeCollectionView()
    let moreCollMsg = makeLabel(withText: "")
    let stackView = makeStackView(withOrientation: .vertical)
    let topView = TopView()
    let bottomView = BottomView()
    
    var bTitle: String?
    var author: String?
    var bImage: String?
    var descr: String?
    var recommendedBooks = [Items]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //MARK: API Call
        
        getRecommandations(for: bTitle!) { (recommendedBooks) in
            guard let similarBooks = recommendedBooks else {
                print("Error fetching books")
                return
            }
            DispatchQueue.main.async {
                self.recommendedBooks = similarBooks
                self.moreCollection.reloadData()
            }
        }
        
        //MARK: Collection View
        moreCollection.dataSource = self
        moreCollection.delegate = self
        moreCollection.register(MoreByCell.self, forCellWithReuseIdentifier: "testIdentifier")
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
        
        //        bottomView.layer.cornerRadius = bottomView.frame.size.height / 25
    }
    
    func setupBookView() {
        
        bookImg.contentMode = .scaleAspectFit
        
        //Text Customization
        bookTitle.font = SetFont.setFontStyle(.regular, 16)
        bookTitle.textColor = .label
        bookTitle.numberOfLines = 1
        bookTitle.lineBreakMode = .byClipping
        bookAuthor.font = SetFont.setFontStyle(.regular, 14)
        bookAuthor.lineBreakMode = .byClipping
        bookAuthor.textColor = UIColor(named: "Accent2")
        descrHeader.font = SetFont.setFontStyle(.medium, 16)
        descrHeader.textColor = UIColor(named: "Color1")
        descrContent.font = SetFont.setFontStyle(.regular, 14)
        descrContent.textColor = .label
        moreByHeader.font = SetFont.setFontStyle(.medium, 16)
        moreByHeader.textColor = UIColor(named: "Color1")
        moreCollMsg.font = SetFont.setFontStyle(.regular, 16)
        moreCollMsg.textColor = .label
        
        //Book Scroll View
        let screenBound = UIScreen.main.bounds
        let middleX = screenBound.width / 2
        let middleY = screenBound.height / 2
        
        let bookSV = UIScrollView(frame: CGRect(x: middleX, y: middleY, width: screenBound.width, height: screenBound.height))
        bookSV.translatesAutoresizingMaskIntoConstraints = false
        bookSV.contentSize = CGSize(width: screenBound.width * 2, height: screenBound.height)
        bookSV.isPagingEnabled = true
        bookSV.alwaysBounceVertical = false
        disableVerticalScroll(bookSV)
        bookSV.layer.cornerRadius = bookSV.frame.size.height / 45
        
        //Creating Scroll View subviews
        let descrView = UIView(frame: CGRect(x: 0, y: 0, width: screenBound.width, height: screenBound.height))
        descrView.translatesAutoresizingMaskIntoConstraints = false
        descrView.backgroundColor = UIColor(named: "Accent9")
        descrView.layer.cornerRadius = descrView.frame.size.height / 45
        
        let moreByView = UIView(frame: CGRect(x: screenBound.width, y: 0, width: screenBound.width, height: screenBound.height))
        moreByView.translatesAutoresizingMaskIntoConstraints = false
        moreByView.backgroundColor = UIColor(named: "Accent9")
        moreByView.layer.cornerRadius = moreByView.frame.size.height / 45

        
        //MARK: Adding the elements to the view
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
        moreByView.addSubview(moreCollection)
        
        view.addSubview(stackView)
        
        // Calculate the percentage of screen width and height for the image size
        let imageWidthPercentage: CGFloat = 0.35
        let imageHeightPercentage: CGFloat = 0.25
        
        let imageWidthConstant = UIScreen.main.bounds.width * imageWidthPercentage
        let imageHeightConstant = UIScreen.main.bounds.height * imageHeightPercentage
        
        
        //MARK: Top View Constraints
        
        bookImg.topAnchor.constraint(equalTo: topView.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        bookImg.centerXAnchor.constraint(equalTo: topView.centerXAnchor).isActive = true
        bookImg.widthAnchor.constraint(equalToConstant: imageWidthConstant).isActive = true
        bookImg.heightAnchor.constraint(equalToConstant: imageHeightConstant).isActive = true
        
        bookTitle.topAnchor.constraint(equalTo: bookImg.bottomAnchor, constant: 8).isActive = true
        bookAuthor.topAnchor.constraint(equalTo: bookTitle.bottomAnchor, constant: 5).isActive = true
        bookTitle.centerXAnchor.constraint(equalTo: topView.centerXAnchor).isActive = true
        bookAuthor.centerXAnchor.constraint(equalTo: topView.centerXAnchor).isActive = true
        
        btnStack.topAnchor.constraint(equalTo: bookAuthor.bottomAnchor, constant: 15).isActive = true
        btnStack.centerXAnchor.constraint(equalTo: topView.centerXAnchor).isActive = true
        btnStack.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -5).isActive = true
        btnStack.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 5).isActive = true
        
        topView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
        topView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        bottomView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
        bottomView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        //MARK: Bottom View Constraints
        
        bookSV.topAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        bookSV.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 15).isActive = true
        bookSV.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -15).isActive = true
        bookSV.bottomAnchor.constraint(equalTo: bottomView.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        //Description View Constraints
        
        descrView.topAnchor.constraint(equalTo: bookSV.topAnchor).isActive = true
        descrView.leadingAnchor.constraint(equalTo: bookSV.leadingAnchor).isActive = true
        descrView.trailingAnchor.constraint(equalTo: moreByView.leadingAnchor).isActive = true
        descrView.widthAnchor.constraint(equalTo: bookSV.widthAnchor).isActive = true
        descrView.bottomAnchor.constraint(equalTo: bookSV.bottomAnchor).isActive = true
        
        descrHeader.topAnchor.constraint(equalTo: descrView.topAnchor, constant: 15).isActive = true
        descrHeader.leadingAnchor.constraint(equalTo: descrView.leadingAnchor, constant: 15).isActive = true
        
        descrContent.topAnchor.constraint(equalTo: descrHeader.bottomAnchor, constant: 8).isActive = true
        descrContent.leadingAnchor.constraint(equalTo: descrView.leadingAnchor,constant: 15).isActive = true
        descrContent.trailingAnchor.constraint(equalTo: descrView.trailingAnchor, constant: -15).isActive = true
        descrContent.bottomAnchor.constraint(equalTo: descrView.bottomAnchor, constant: -5).isActive = true
        
        //More View
        
        moreByView.topAnchor.constraint(equalTo: bookSV.topAnchor).isActive = true
        moreByView.leadingAnchor.constraint(equalTo: descrView.trailingAnchor).isActive = true
        moreByView.widthAnchor.constraint(equalTo: bookSV.widthAnchor).isActive = true
        moreByView.trailingAnchor.constraint(equalTo: bookSV.trailingAnchor).isActive = true
//        moreByView.bottomAnchor.constraint(equalTo: bookSV.bottomAnchor).isActive = true
        moreByView.heightAnchor.constraint(equalTo: moreCollection.heightAnchor, multiplier: 1.25).isActive = true
        
        moreByHeader.topAnchor.constraint(equalTo: moreByView.topAnchor, constant: 15).isActive = true
        moreByHeader.leadingAnchor.constraint(equalTo: moreByView.leadingAnchor, constant: 15).isActive = true
        
        moreCollection.topAnchor.constraint(equalTo: moreByHeader.bottomAnchor, constant: 5).isActive = true
        moreCollection.leadingAnchor.constraint(equalTo: moreByView.leadingAnchor, constant: 5).isActive = true
        moreCollection.trailingAnchor.constraint(equalTo: moreByView.trailingAnchor, constant: -5).isActive = true
        moreCollection.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
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
        if recommendedBooks.count == 0 {
            moreCollMsg.isHidden = false
            moreCollMsg.text = EmptyTable.collectionMessage.randomElement()!
            moreCollection.isHidden = true
        }else{
            moreCollMsg.isHidden = true
            moreCollection.isHidden = false
        }
        return recommendedBooks.count
    }
    
    // Configure the cells
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "testIdentifier", for: indexPath) as! MoreByCell
        // Customize the cell's content based on the data
        cell.titleLabel?.text = recommendedBooks[indexPath.row].volumeInfo.title
        
        if let imageURLString = recommendedBooks[indexPath.row].volumeInfo.imageLinks?.thumbnail,
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
