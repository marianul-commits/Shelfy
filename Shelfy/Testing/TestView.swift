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

//class TestView: UIViewController {
//    
//
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//
//    }
//
//    func setupUI() {
//        
//        view.backgroundColor = UIColor(resource: .background)
//        
//        
//    }
//
//}

class TestView: UIViewController {
    

    let spacer = UIView()
    
    // Define UICollectionView
    lazy var collectionView = makeCollectionView2(data)
    
    // Data source
    let data = [
        "🖋️ Fiction",
        "🔍 Thriller",
        "🧚 Fantasy",
        "💖 Romance",
        "👽 Science Fiction",
        "✨ Young Adult",
        "🧘‍♂️ Self-Help",
        "💵 Finance",
        "🏥 Health"
    ]

    var trendingNowLbl = makeLabel(withText: "Trending Now")
    lazy var trendingBookCover = UIImageView()
    var trendingBCPlaceholder = UIView()
    var trendingBTPlaceholder = UILabel()
    lazy var randomBook = ""
    lazy var coverID = ""
    lazy var bookID = ""
    var trendingView = UIView()
    lazy var trendingBookTitle = UILabel()
    lazy var header = UILabel()
    lazy var trendingBookAuthor = UILabel()
    lazy var bookAuthor = ""
    var randomGenre = K.topGenres.randomElement()
    lazy var errorLbl = UILabel()
    let stackView = UIStackView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let randomCateg = data.randomElement()!.components(separatedBy: " ").dropFirst().joined(separator: " ")
                
        //API Call
        pickRandomBook(fromGenre: randomCateg) { title, coverID, authorName, bookKey in
            if let title = title, let coverID = coverID, let bookKey = bookKey {
                self.randomBook = title
                self.coverID = coverID
                self.bookID = bookKey
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) { // Stop Skeleton View & Display Book
                    self.stopLoading()
                    self.trendingBookTitle.text = title
                    self.trendingBookAuthor.text = "By \(authorName!)"
                    self.bookAuthor = "\(authorName!)"
                    downloadCoverImage(coverImageID: "\(coverID)", targetImageView: self.trendingBookCover, placeholderImage: UIImage(resource: .placeholder))
                    UIView.animate(withDuration: 1.5, delay: 0.5, options: [.curveEaseIn], animations: {
                        self.trendingBookCover.alpha = 1.0
                        self.trendingBookTitle.alpha = 1.0
                        self.header.alpha = 1.0
                        self.trendingBookAuthor.alpha = 1.0
                    }, completion: nil)
                    self.stopLoading()
                }
            } else {
                print("Failed to fetch a random book")
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) { // Stop Skeleton View & Display Error
                    self.stopLoading()
                    UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseIn], animations: {
                        self.errorLbl.alpha = 1.0
                        self.header.alpha = 0.0
                    }, completion: nil)
                    if self.trendingBookTitle.text == nil && self.trendingBookAuthor.text == nil || ((self.trendingBookAuthor.text?.isEmpty) != nil) {
                        self.errorLbl.text = K.errorLbl
                    }
                }//End DQ
            }//End else
        } //End API Call
        
        trendingBookCover.alpha = 0.0
        trendingBookTitle.alpha = 0.0
        trendingBookAuthor.alpha = 0.0
        errorLbl.alpha = 0.0
        
        header.text = "Hot in \(randomCateg)"
        
        trendingBTPlaceholder.text = K.placeholder
        
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        trendingBTPlaceholder.textAlignment = .center
        trendingBTPlaceholder.numberOfLines = 2
        
        trendingView.translatesAutoresizingMaskIntoConstraints = false
        trendingBookCover.translatesAutoresizingMaskIntoConstraints = false
        trendingBookTitle.translatesAutoresizingMaskIntoConstraints = false
        trendingBCPlaceholder.translatesAutoresizingMaskIntoConstraints = false
        trendingBTPlaceholder.translatesAutoresizingMaskIntoConstraints = false
        header.translatesAutoresizingMaskIntoConstraints = false
        trendingBookAuthor.translatesAutoresizingMaskIntoConstraints = false
        errorLbl.translatesAutoresizingMaskIntoConstraints = false
        trendingBookTitle.numberOfLines = 0
        trendingBookTitle.lineBreakMode = .byWordWrapping
        trendingBookTitle.textAlignment = .center
        trendingBookAuthor.numberOfLines = 0
        trendingBookAuthor.lineBreakMode = .byWordWrapping
        trendingBookAuthor.textAlignment = .center
        trendingBTPlaceholder.linesCornerRadius = 5
        
        
        errorLbl.numberOfLines = 0
        errorLbl.lineBreakMode = .byWordWrapping
        errorLbl.textAlignment = .center
        
        trendingView.layer.cornerRadius = 12
        trendingBookCover.layer.cornerRadius = 10
        trendingBookCover.clipsToBounds = true
        trendingView.clipsToBounds = true
        trendingBookCover.contentMode = .scaleAspectFit
        trendingBookTitle.font = SetFont.setFontStyle(.medium, 14)
        trendingBookAuthor.font = SetFont.setFontStyle(.medium, 14)
        header.font = SetFont.setFontStyle(.medium, 16)
        errorLbl.font = SetFont.setFontStyle(.medium, 16)
        trendingNowLbl.font = SetFont.setFontStyle(.medium, 22)
        
        spacer.translatesAutoresizingMaskIntoConstraints = false
        //        spacer.backgroundColor = .systemPink
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        
        
        // Add UICollectionView to the view
        view.addSubview(collectionView)
        view.addSubview(trendingView)
        view.addSubview(trendingNowLbl)
        trendingView.addSubview(trendingBookCover)
        trendingView.addSubview(trendingBCPlaceholder)
        trendingView.addSubview(trendingBookTitle)
        trendingView.addSubview(header)
        trendingView.addSubview(trendingBookAuthor)
        trendingView.addSubview(errorLbl)
        trendingView.addSubview(stackView)
        stackView.addArrangedSubview(trendingBTPlaceholder)
        view.addSubview(spacer)
        
        let imageWidthPercentage: CGFloat = 0.32
        let imageHeightPercentage: CGFloat = 0.42
        let placeholderPercentage: CGFloat = 0.32
        
        let imageWidthConstant = UIScreen.main.bounds.width * imageWidthPercentage
        let imageHeightConstant = UIScreen.main.bounds.height * imageHeightPercentage
        
        let placeholderWidthConstant = trendingView.bounds.width * imageWidthPercentage
        let placeholderHeightConstant = trendingView.bounds.height * placeholderPercentage
        
        let placehoderHeight = trendingBCPlaceholder.heightAnchor.constraint(equalToConstant: placeholderHeightConstant / 1.25)
        placehoderHeight.isActive = true
        placehoderHeight.priority = UILayoutPriority(rawValue: 995)
        
        // Set constraints for the collection view
        NSLayoutConstraint.activate([
            
            collectionView.topAnchor.constraint(equalTo: trendingNowLbl.bottomAnchor, constant: 12),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            collectionView.bottomAnchor.constraint(equalTo: header.topAnchor,constant: -24),
            collectionView.heightAnchor.constraint(equalToConstant: 80),
            
            trendingNowLbl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            trendingNowLbl.leadingAnchor.constraint(equalTo: trendingView.leadingAnchor),
            
            trendingView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 12),
            trendingView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trendingView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            trendingView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            
            trendingBookCover.leadingAnchor.constraint(equalTo: trendingView.leadingAnchor, constant: 10),
            trendingBookCover.trailingAnchor.constraint(lessThanOrEqualTo: trendingBookTitle.leadingAnchor, constant: -8),
            trendingBookCover.bottomAnchor.constraint(equalTo: trendingView.bottomAnchor, constant: -16),
            trendingBookCover.widthAnchor.constraint(equalToConstant: imageWidthConstant),
            trendingBookCover.heightAnchor.constraint(lessThanOrEqualToConstant: imageHeightConstant),
            
            trendingBCPlaceholder.leadingAnchor.constraint(equalTo: trendingBookCover.leadingAnchor),
            trendingBCPlaceholder.trailingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: -8),
            trendingBCPlaceholder.widthAnchor.constraint(lessThanOrEqualToConstant: placeholderWidthConstant),
            trendingBCPlaceholder.topAnchor.constraint(equalTo: header.bottomAnchor),
            
            trendingBookTitle.centerYAnchor.constraint(equalTo: trendingView.centerYAnchor),
            trendingBookTitle.leadingAnchor.constraint(equalTo: trendingBookCover.trailingAnchor, constant: 16),
            trendingBookTitle.trailingAnchor.constraint(equalTo: trendingView.trailingAnchor, constant: -16),
            
            trendingBookAuthor.topAnchor.constraint(equalTo: trendingBookTitle.bottomAnchor, constant: 8),
            trendingBookAuthor.leadingAnchor.constraint(equalTo: trendingBookCover.trailingAnchor, constant: 16),
            trendingBookAuthor.trailingAnchor.constraint(equalTo: trendingView.trailingAnchor, constant: -16),
            
            stackView.widthAnchor.constraint(equalTo: trendingView.widthAnchor, multiplier: 0.55),
            stackView.topAnchor.constraint(equalTo: trendingView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: trendingView.bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: trendingView.trailingAnchor, constant: -16),
            
            trendingBTPlaceholder.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
            trendingBTPlaceholder.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: -0.25),
            
            header.centerXAnchor.constraint(equalTo: trendingView.centerXAnchor),
            header.topAnchor.constraint(equalTo: trendingView.topAnchor, constant: 8),
            header.bottomAnchor.constraint(lessThanOrEqualTo: trendingBookCover.topAnchor, constant: -16),
            header.heightAnchor.constraint(equalToConstant: 20),
            
            errorLbl.centerXAnchor.constraint(equalTo: trendingView.centerXAnchor),
            errorLbl.leadingAnchor.constraint(equalTo: trendingView.leadingAnchor, constant: 16),
            errorLbl.trailingAnchor.constraint(equalTo: trendingView.trailingAnchor, constant: -16),
            errorLbl.topAnchor.constraint(equalTo: trendingView.topAnchor, constant: 16),
            errorLbl.bottomAnchor.constraint(equalTo: trendingView.bottomAnchor, constant: -16),
            
        ])
        
    }


func startLoading() {
    
    trendingBTPlaceholder.showAnimatedSkeleton()
    trendingBTPlaceholder.skeletonTextNumberOfLines = 2
    trendingBCPlaceholder.showAnimatedSkeleton()
    trendingBCPlaceholder.isHiddenWhenSkeletonIsActive = true
    trendingBTPlaceholder.isHiddenWhenSkeletonIsActive = true
    trendingBTPlaceholder.isHidden = false
    trendingBCPlaceholder.isHidden = false
    self.header.alpha = 1.0
    
}

func stopLoading() {
    
    trendingBTPlaceholder.hideSkeleton(transition: .crossDissolve(0.25))
    trendingBCPlaceholder.hideSkeleton(transition: .crossDissolve(0.25))
    trendingBTPlaceholder.isHidden = true
    trendingBCPlaceholder.isHidden = true
    trendingView.layer.cornerRadius = 12
    trendingView.clipsToBounds = true
    
}
    
}

extension TestView: UICollectionViewDelegate {
    
}


extension TestView: UICollectionViewDataSource{
    // MARK: - UICollectionViewDataSource Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .clear
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height))
        label.textAlignment = .center
        label.clipsToBounds = true
        label.textColor = UIColor(resource: .textBG)
        label.backgroundColor = UIColor(resource: .background)
        label.layer.borderWidth = 2
        label.layer.borderColor = UIColor(resource: .brandLogo).cgColor
        label.layer.cornerRadius = 15
        label.text = data[indexPath.item]
        cell.contentView.addSubview(label)
        cell.clipsToBounds = true
//        cell.layer.cornerRadius = 15
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected item: \(data[indexPath.item])")
        
        let category = data[indexPath.item].components(separatedBy: " ").dropFirst().joined(separator: " ")
                    
        DispatchQueue.main.async {
            self.startLoading()
        }
        
            //API Call
            pickRandomBook(fromGenre: category) { title, coverID, authorName, bookKey in
                if let title = title, let coverID = coverID, let bookKey = bookKey {
                    self.randomBook = title
                    self.coverID = coverID
                    self.bookID = bookKey
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) { // Stop Skeleton View & Display Book
                        self.stopLoading()
                        self.trendingBookTitle.text = title
                        self.trendingBookAuthor.text = "By \(authorName!)"
                        self.bookAuthor = "\(authorName!)"
                        self.errorLbl.alpha = 0.0
                        self.header.text = "Hot in \(category)"
                        downloadCoverImage(coverImageID: "\(coverID)", targetImageView: self.trendingBookCover, placeholderImage: UIImage(resource: .placeholder))
                        UIView.animate(withDuration: 1.5, delay: 0.5, options: [.curveEaseIn], animations: {
                            self.trendingBookCover.alpha = 1.0
                            self.trendingBookTitle.alpha = 1.0
                            self.header.alpha = 1.0
                            self.trendingBookAuthor.alpha = 1.0
                        }, completion: nil)
                        self.stopLoading()
                    }
                } else {
                    print("Failed to fetch a random book")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) { // Stop Skeleton View & Display Error
                        self.stopLoading()
                        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseIn], animations: {
                            self.errorLbl.alpha = 1.0
                            self.header.alpha = 0.0
                            self.trendingBookAuthor.alpha = 0.0
                            self.trendingBookTitle.alpha = 0.0
                            self.trendingBookCover.alpha = 0.0
                        }, completion: nil)
                        if self.trendingBookTitle.text == nil && self.trendingBookAuthor.text == nil || ((self.trendingBookAuthor.text?.isEmpty) != nil) {
                            self.errorLbl.text = K.errorLbl
                        }
                    }//End DQ
                }//End else
            } //End API Call
        }
}
