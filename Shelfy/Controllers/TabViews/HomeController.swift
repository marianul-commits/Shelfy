//
//  ViewController.swift
//  Shelfy
//
//  Created by Marian Nasturica on 04.06.2023.
//

import UIKit
import CoreData

class HomeController: UIViewController {
    
    //Core Data
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var bookPages: [String] = []
    var bookTotalPages: [String] = []
    
    //Level Progress
    
    var levelProgressBar = makeProgressBar()
    let user: String = UserDefaults.standard.string(forKey: "username") ?? "User"
    var greetingUser = makeLabel(withText: "")
    var userLevel = makeLabel(withText: "")
    var levelPBLabel = makeLabel(withText: "")
    let lvlLogic = LevelManager()
    var pagesReadWhenLeaving: Int = 0
    
    //Last Accessed Book Values
    var lastAccessedTitle: String?
    var lastAccessedAuthor: String?
    var lastAccessedPagesRead: Int?
    var lastAccessedPagesTotal: Int?
    var lastAccessedID: String?
    var lastAccessedCover: String?
    
    //Trending Now View
    var selectedIndexPath = IndexPath()
    let bookCategories = K.bookCategories
    lazy var collectionView = makeCollectionView2(bookCategories)
    var trendingNowLbl = UILabel()
    lazy var trendingBookCover = UIImageView()
    var trendingBCPlaceholder = UIView()
    var trendingBTPlaceholder = UILabel()
    lazy var randomBook = ""
    lazy var coverID = ""
    lazy var bookID = ""
    var trendingView = UIView()
    lazy var trendingBookTitle = UILabel()
    lazy var trendingBookAuthor = UILabel()
    lazy var bookAuthor = ""
    var randomGenre = K.topGenres.randomElement()
    lazy var errorLbl = UILabel()
    let stackView = UIStackView()
    
    //Continue Tracking View
    
    var continueReadingContainer = UIView()
    var continueHeader = makeLabel(withText: "Continue tracking")
    var continueSubtitle = makeLabel(withText: "Ready to dive back in?")
    var continueProgressBar = UIProgressView()
    var continueProgressLbl = UILabel()
    let pageDisplay = PageStyleManager.shared
    var continueBookPhoto = UIImageView()
    lazy var continueTotalPgs = 0
    lazy var continueReadPgs = 0
    
    //MARK: View Will Appear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        //Selecting Random Genre
        let randomCateg = bookCategories.randomElement()!.components(separatedBy: " ").dropFirst().joined(separator: " ")
        
        fetchLastAccessedBook()
        
        
        
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
                        self.trendingNowLbl.alpha = 1.0
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
                        self.trendingNowLbl.text = "Trending Now"
                    }, completion: nil)
                    if self.trendingBookTitle.text == nil && self.trendingBookAuthor.text == nil || ((self.trendingBookAuthor.text?.isEmpty) != nil) {
                        self.errorLbl.text = K.errorLbl
                    }
                }//End DQ
            }//End else
        } //End API Call
    } //End viewWillAppear
    
    //MARK: View Did Appear
    
    override func viewDidAppear(_ animated: Bool) {
        
        let intBooks = self.bookPages.map { Int($0) ?? 0 }
        let pageValue = intBooks.reduce(0, +)
        
        startLoading() // Display Skeleton View
        errorLbl.alpha = 0.0
        self.trendingBookCover.alpha = 0.0
        self.trendingBookTitle.alpha = 0.0
        self.trendingBookAuthor.alpha = 0.0
        self.errorLbl.alpha = 0.0
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllBookPages() //Core Data Call for bookPages & bookTotalPages values
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleNotification(_:)),
                                               name: .bookChanged,
                                               object: nil)
        
        setupView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //        clearObserver()
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
        DispatchQueue.main.async { //Hiding the current values to better display new ones upon coming back
            
            self.trendingBookCover.alpha = 0.0
            self.trendingBookTitle.alpha = 0.0
            self.trendingBookAuthor.alpha = 0.0
            self.errorLbl.alpha = 0.0
            
        }
    }
    
    func setupView() {
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        
        let intBooks = self.bookPages.map { Int($0) ?? 0 }
        let pagesRead = intBooks.reduce(0, +)
        lvlLogic.updateProgress(pagesRead: pagesRead)
        
        trendingBookCover.alpha = 0.0
        trendingBookTitle.alpha = 0.0
        trendingBookAuthor.alpha = 0.0
        errorLbl.alpha = 0.0
        
        let randomCateg = bookCategories.randomElement()!.components(separatedBy: " ").dropFirst().joined(separator: " ")
        
        trendingNowLbl.text = "Trending in \(randomCateg)"
        
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
        trendingNowLbl.translatesAutoresizingMaskIntoConstraints = false
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
        
        
        trendingView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        K.setGradientBackground(view: trendingView, colorTop: UIColor(resource: .brandPurple), colorBottom: UIColor(resource: .brandDarkPurple))
        trendingBCPlaceholder.skeletonCornerRadius = 10
        
        let seeBook = UITapGestureRecognizer(target: self, action: #selector(bookTapped))
        trendingView.addGestureRecognizer(seeBook)
        
        let seeLastBook = UITapGestureRecognizer(target: self, action: #selector(lastBookTapped))
        continueReadingContainer.addGestureRecognizer(seeLastBook)
        
        trendingView.layer.cornerRadius = 12
        trendingBookCover.layer.cornerRadius = 10
        trendingBookCover.clipsToBounds = true
        trendingView.clipsToBounds = true
        trendingBookCover.contentMode = .scaleAspectFit
        trendingBookTitle.font = SetFont.setFontStyle(.medium, 14)
        trendingBookAuthor.font = SetFont.setFontStyle(.medium, 14)
        errorLbl.font = SetFont.setFontStyle(.medium, 16)
        trendingNowLbl.font = SetFont.setFontStyle(.medium, 22)
        
        continueBookPhoto.image = UIImage(resource: .placeholder)
        
        fetchLastAccessedBook() //Core Data call to last accessed book using bookLastAccesed
        
        continueReadingContainer.translatesAutoresizingMaskIntoConstraints = false
        continueHeader.translatesAutoresizingMaskIntoConstraints = false
        continueSubtitle.translatesAutoresizingMaskIntoConstraints = false
        continueProgressBar.translatesAutoresizingMaskIntoConstraints = false
        continueProgressLbl.translatesAutoresizingMaskIntoConstraints = false
        continueBookPhoto.translatesAutoresizingMaskIntoConstraints = false
        
        continueProgressBar.progress = 0
        continueProgressBar.tintColor = UIColor(resource: .brandDarkPurple)
        continueProgressBar.trackTintColor = UIColor(resource: .brandPurple)
        continueProgressBar.progressViewStyle = .bar
        continueProgressBar.layer.cornerRadius = 2
        continueProgressBar.clipsToBounds = true
        
        continueProgressLbl.text = "Page XX of YYY"
        
        continueHeader.font = SetFont.setFontStyle(.medium, 16)
        continueSubtitle.font = SetFont.setFontStyle(.regular, 14)
        continueProgressLbl.font = SetFont.setFontStyle(.regular, 14)
        
        
        continueReadingContainer.clipsToBounds = true
        continueReadingContainer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        continueReadingContainer.layer.cornerRadius = 12
        K.setGradientBackground(view: continueReadingContainer, colorTop: UIColor(resource: .brandDarkMint), colorBottom: UIColor(resource: .brandMint))
        
        
        continueBookPhoto.clipsToBounds = true
        continueBookPhoto.layer.cornerRadius = 16
        
        
        view.addSubview(trendingView)
        view.addSubview(collectionView)
        trendingView.addSubview(trendingBookCover)
        trendingView.addSubview(trendingBCPlaceholder)
        trendingView.addSubview(trendingBookTitle)
        trendingView.addSubview(trendingBookAuthor)
        trendingView.addSubview(errorLbl)
        trendingView.addSubview(stackView)
        stackView.addArrangedSubview(trendingBTPlaceholder)
        view.addSubview(continueReadingContainer)
        continueReadingContainer.addSubview(continueHeader)
        continueReadingContainer.addSubview(continueSubtitle)
        continueReadingContainer.addSubview(continueProgressLbl)
        continueReadingContainer.addSubview(continueProgressBar)
        continueReadingContainer.addSubview(continueBookPhoto)
        
        greetingUser.text = K.greetUser(user: user)
        greetingUser.font = SetFont.setFontStyle(.medium, 22)
        userLevel.text = lvlLogic.currentLevelTitle
        userLevel.font = SetFont.setFontStyle(.medium, 18)
        
        let progressLblValue = lvlLogic.currentValue * 100
        levelProgressBar.progress = lvlLogic.currentValue
        
        levelPBLabel.text = String(format: "%.0f%%", progressLblValue)
        levelProgressBar.tintColor = UIColor(resource: .brandPurple)
        levelProgressBar.trackTintColor = UIColor(resource: .brandDarkPurple)
        levelProgressBar.progressViewStyle = .bar
        levelProgressBar.layer.cornerRadius = 2
        levelProgressBar.clipsToBounds = true
        
        trendingBTPlaceholder.isSkeletonable = true
        trendingBCPlaceholder.isSkeletonable = true
        
        view.addSubview(greetingUser)
        view.addSubview(userLevel)
        view.addSubview(levelProgressBar)
        view.addSubview(levelPBLabel)
        view.addSubview(trendingNowLbl)
        
        NSLayoutConstraint.activate([
            greetingUser.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            greetingUser.leadingAnchor.constraint(equalTo: userLevel.leadingAnchor),
            userLevel.topAnchor.constraint(equalTo: greetingUser.bottomAnchor, constant: 12),
            userLevel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            userLevel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            levelProgressBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            levelProgressBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            levelProgressBar.heightAnchor.constraint(equalToConstant: 2),
            levelProgressBar.topAnchor.constraint(equalTo: userLevel.bottomAnchor, constant: 12),
            levelPBLabel.topAnchor.constraint(equalTo: levelProgressBar.bottomAnchor, constant: 8),
            levelPBLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            trendingNowLbl.topAnchor.constraint(equalTo: levelPBLabel.bottomAnchor, constant: 24),
            trendingNowLbl.leadingAnchor.constraint(equalTo: trendingView.leadingAnchor),
            
            trendingView.topAnchor.constraint(equalTo: trendingNowLbl.bottomAnchor, constant: 84),
            trendingView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trendingView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            trendingView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.27),
            
            trendingBookCover.leadingAnchor.constraint(equalTo: trendingView.leadingAnchor, constant: 10),
            trendingBookCover.trailingAnchor.constraint(lessThanOrEqualTo: trendingBookTitle.leadingAnchor, constant: -8),
            trendingBookCover.centerYAnchor.constraint(equalTo: trendingView.centerYAnchor),
            trendingBookCover.widthAnchor.constraint(equalTo: trendingView.widthAnchor, multiplier: 0.32),
            trendingBookCover.heightAnchor.constraint(equalTo: trendingView.heightAnchor, constant: -16),
            
            
            trendingBCPlaceholder.leadingAnchor.constraint(equalTo: trendingBookCover.leadingAnchor),
            trendingBCPlaceholder.widthAnchor.constraint(equalTo: trendingView.widthAnchor, multiplier: 0.32),
            trendingBCPlaceholder.centerYAnchor.constraint(equalTo: trendingView.centerYAnchor),
            trendingBCPlaceholder.heightAnchor.constraint(equalTo: trendingView.heightAnchor, constant: -16),
            
            trendingBookTitle.centerYAnchor.constraint(equalTo: trendingView.centerYAnchor),
            trendingBookTitle.leadingAnchor.constraint(equalTo: trendingBookCover.trailingAnchor, constant: 16),
            trendingBookTitle.trailingAnchor.constraint(equalTo: trendingView.trailingAnchor, constant: -16),
            
            trendingBookAuthor.topAnchor.constraint(equalTo: trendingBookTitle.bottomAnchor, constant: 8),
            trendingBookAuthor.leadingAnchor.constraint(equalTo: trendingBookCover.trailingAnchor, constant: 16),
            trendingBookAuthor.trailingAnchor.constraint(equalTo: trendingView.trailingAnchor, constant: -16),
            
            stackView.widthAnchor.constraint(equalTo: trendingView.widthAnchor, multiplier: 0.55),
            stackView.centerYAnchor.constraint(equalTo: trendingView.centerYAnchor),
            stackView.trailingAnchor.constraint(equalTo: trendingView.trailingAnchor, constant: -16),
            
            trendingBTPlaceholder.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
            trendingBTPlaceholder.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: -0.25),
            
            collectionView.topAnchor.constraint(equalTo: trendingNowLbl.bottomAnchor, constant: 12),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            collectionView.bottomAnchor.constraint(equalTo: trendingView.topAnchor,constant: -24),
            
            errorLbl.centerXAnchor.constraint(equalTo: trendingView.centerXAnchor),
            errorLbl.leadingAnchor.constraint(equalTo: trendingView.leadingAnchor, constant: 16),
            errorLbl.trailingAnchor.constraint(equalTo: trendingView.trailingAnchor, constant: -16),
            errorLbl.topAnchor.constraint(equalTo: trendingView.topAnchor, constant: 16),
            errorLbl.bottomAnchor.constraint(equalTo: trendingView.bottomAnchor, constant: -16),
            
            continueReadingContainer.topAnchor.constraint(equalTo: trendingView.bottomAnchor, constant: 24),
            continueReadingContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            continueReadingContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            continueReadingContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15),
            
            continueBookPhoto.topAnchor.constraint(equalTo: continueReadingContainer.topAnchor, constant: 4),
            continueBookPhoto.trailingAnchor.constraint(equalTo: continueReadingContainer.trailingAnchor, constant: -4),
            continueBookPhoto.bottomAnchor.constraint(equalTo: continueReadingContainer.bottomAnchor, constant: -4),
            continueBookPhoto.widthAnchor.constraint(equalTo: continueReadingContainer.widthAnchor, multiplier: 0.2),
            continueBookPhoto.heightAnchor.constraint(equalTo: continueReadingContainer.heightAnchor, constant: -8),
            
            continueHeader.topAnchor.constraint(equalTo: continueReadingContainer.topAnchor, constant: 12),
            continueHeader.leadingAnchor.constraint(equalTo: continueReadingContainer.leadingAnchor, constant: 12),
            continueHeader.trailingAnchor.constraint(equalTo: continueBookPhoto.leadingAnchor, constant: 12),
            
            continueSubtitle.topAnchor.constraint(equalTo: continueHeader.bottomAnchor, constant: 8),
            continueSubtitle.leadingAnchor.constraint(equalTo: continueReadingContainer.leadingAnchor, constant: 12),
            continueSubtitle.trailingAnchor.constraint(equalTo: continueBookPhoto.leadingAnchor, constant: 24),
            
            continueProgressLbl.leadingAnchor.constraint(equalTo: continueReadingContainer.leadingAnchor, constant: 12),
            continueProgressLbl.trailingAnchor.constraint(equalTo: continueBookPhoto.leadingAnchor, constant: 12),
            continueProgressLbl.topAnchor.constraint(equalTo: continueProgressBar.topAnchor, constant: -24),
            
            continueProgressBar.leadingAnchor.constraint(equalTo: continueReadingContainer.leadingAnchor, constant: 12),
            continueProgressBar.trailingAnchor.constraint(equalTo: continueBookPhoto.leadingAnchor, constant: -12),
            continueProgressBar.bottomAnchor.constraint(equalTo: continueReadingContainer.bottomAnchor, constant: -12),
            
        ])
        
        startLoading()
        
    }
    
    func getAllBookPages() {
        // Create a fetch request to fetch all BookItem objects
        let fetchRequest: NSFetchRequest<BookItem> = BookItem.fetchRequest()
        
        do {
            // Execute the fetch request
            let bookItems = try context.fetch(fetchRequest)
            
            // Iterate over the fetched BookItem objects
            for bookItem in bookItems {
                // Extract the bookPages and bookTotalPages attributes from each BookItem
                if let bookPage = bookItem.bookPages {
                    bookPages.append(bookPage)
                }
                if let bookTotalPage = bookItem.bookTotalPages {
                    bookTotalPages.append(bookTotalPage)
                }
            }
        } catch {
            print("Error fetching book items: \(error)")
        }
    }
    
    func calculateProgress(pagesRead: Int, totalPages: Int) -> Float {
        guard totalPages > 0 else {
            return 0.0 // If total pages is zero or negative, return 0 progress
        }
        
        // Calculate the progress percentage
        let progress = Float(pagesRead) / Float(totalPages)
        return progress // Ensure progress does not exceed 100%
    }
    
    func startLoading() {
        
        trendingBTPlaceholder.showAnimatedSkeleton()
        trendingBTPlaceholder.skeletonTextNumberOfLines = 2
        trendingBCPlaceholder.showAnimatedSkeleton()
        trendingBCPlaceholder.isHiddenWhenSkeletonIsActive = true
        trendingBTPlaceholder.isHiddenWhenSkeletonIsActive = true
        trendingBTPlaceholder.isHidden = false
        trendingBCPlaceholder.isHidden = false
        self.trendingNowLbl.alpha = 1.0
        
    }
    
    func stopLoading() {
        
        trendingBTPlaceholder.hideSkeleton(transition: .crossDissolve(0.25))
        trendingBCPlaceholder.hideSkeleton(transition: .crossDissolve(0.25))
        trendingBTPlaceholder.isHidden = true
        trendingBCPlaceholder.isHidden = true
        trendingView.layer.cornerRadius = 12
        trendingView.clipsToBounds = true
        
    }
    
    //MARK: Fetch Last Accessed Book
    func fetchLastAccessedBook() {
        let fetchRequest: NSFetchRequest<BookItem> = BookItem.fetchRequest()
        
        // Sort the fetch request by lastAccessedDate in descending order
        let sortDescriptor = NSSortDescriptor(key: "bookLastAccessed", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Limit the fetch request to return only the last item
        fetchRequest.fetchLimit = 1
        
        do {
            let result = try context.fetch(fetchRequest)
            
            for item in result {
                DispatchQueue.main.async {
                    //Retrieve Values from CoreData
                    let coverID = item.bookCover
                    let bookID = item.bookKey
                    let bookTitle = item.bookTitle
                    let bookAuthor = item.bookAuthor
                    let totalPgsString = item.bookTotalPages
                    let totalPgsInt = Int(totalPgsString ?? "0")
                    let readPgsString = item.bookPages
                    let readPgsInt = Int(readPgsString ?? "0")
                    
                    //Set Values for Continue Reading view & Segue
                    self.lastAccessedAuthor = bookAuthor
                    self.lastAccessedTitle = bookTitle
                    self.lastAccessedID = bookID
                    self.lastAccessedCover = coverID
                    self.lastAccessedPagesTotal = totalPgsInt
                    self.lastAccessedPagesRead = readPgsInt
                    self.continueTotalPgs = totalPgsInt ?? 0
                    self.continueReadPgs = readPgsInt ?? 0
                    self.continueProgressBar.progress = self.calculateProgress(pagesRead: self.continueReadPgs, totalPages: self.continueTotalPgs)
                    downloadCoverImage(coverImageID: "\(coverID!)", targetImageView: self.continueBookPhoto, placeholderImage: UIImage(resource: .placeholder))
                    self.continueProgressLbl.text = self.pageDisplay.updateProgressLabel(pagesRead: self.continueReadPgs, totalPages: self.continueTotalPgs, progressLbl: self.continueProgressLbl)
                }
            }
            
        } catch {
            print("Error fetching last two accessed items: \(error)")
        }
    }
    
    @objc func bookTapped() {
        // Instantiate and present the second view controller
        let detailVC = BookView()
        
        detailVC.bookID = bookID
        detailVC.bTitle = trendingBookTitle.text
        detailVC.bAuthor = bookAuthor
        detailVC.bImage = Int(coverID)
        
        
        let coverID = self.coverID
        downloadCoverImage(coverImageID: "\(coverID)", targetImageView: detailVC.bookImg, placeholderImage: UIImage(resource: .placeholder))
        
        present(detailVC, animated: true, completion: nil)
    }
    
    func clearObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    //MARK: Pages Read Notification Update
    @objc func handleNotification(_ notification: Notification) {
        
        let pageNewValue = notification.userInfo?["newPagesRead"] as? Int
        
        print("I received something!")
        //        print("pageNewValue: ", pageNewValue!)
        
        let intBooks = self.bookPages.map { Int($0) ?? 0 }
        let pagesRead = intBooks.reduce(0, +)
        var pagesReadValue = pagesRead
        
        print("pagesRead: ", pagesRead)
        
        let newValue = pagesRead + pageNewValue!
        
        print("newValue: ", newValue)
        
        if newValue > pagesRead {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                let intBooks = self.bookPages.map { Int($0) ?? 0 }
                let intTotalPages = self.bookTotalPages.map { Int($0) ?? 0 }
                let pagesRead = intBooks.reduce(0, +)
                self.levelProgressBar.setProgress(self.lvlLogic.updateProgressIfNeeded(pagesRead: newValue), animated: true)
                let progressLblValue = self.lvlLogic.currentValue * 100
                self.levelPBLabel.text = String(format: "%.0f%%", progressLblValue)
                self.userLevel.text = self.lvlLogic.currentLevelTitle
            } // Setting the values for ProgressBar.progress
        } else if newValue < pagesRead {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                let intBooks = self.bookPages.map { Int($0) ?? 0 }
                let intTotalPages = self.bookTotalPages.map { Int($0) ?? 0 }
                let pagesRead = intBooks.reduce(0, +)
                self.levelProgressBar.setProgress(self.lvlLogic.updateProgressIfNeeded(pagesRead: newValue), animated: true)
                let progressLblValue = self.lvlLogic.currentValue * 100
                self.levelPBLabel.text = String(format: "%.0f%%", progressLblValue)
                self.userLevel.text = self.lvlLogic.currentLevelTitle
            } // Setting the values for ProgressBar.progress
        }
        pagesReadValue = newValue
        print("pagesReadValue: ", pagesReadValue)
    }
    
    @objc func lastBookTapped() {
        
        let detailVC = TrackBookView()
        
        detailVC.bookID = lastAccessedID
        detailVC.bookTitle = lastAccessedTitle
        detailVC.bookAuthor = lastAccessedAuthor
        detailVC.bookImg = lastAccessedCover
        detailVC.pagesRead = lastAccessedPagesRead!
        
        let coverID = lastAccessedID!
        downloadCoverImage(coverImageID: "\(coverID)", targetImageView: detailVC.bImage, placeholderImage: UIImage(resource: .placeholder))
        
        detailVC.view.backgroundColor = UIColor(resource: .background)
        
        present(detailVC, animated: true, completion: nil)
    }
    
}

extension HomeController: UICollectionViewDataSource, UICollectionViewDelegate{
    // MARK: - UICollectionViewDataSource Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookCategories.count
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let category = bookCategories[indexPath.item].components(separatedBy: " ").dropFirst().joined(separator: " ")
        
        selectedIndexPath = indexPath
        
        DispatchQueue.main.async {
            self.startLoading()
            self.trendingBookCover.alpha = 0
            self.trendingBookTitle.alpha = 0
            self.trendingBookAuthor.alpha = 0
            self.errorLbl.alpha = 0
            self.trendingNowLbl.text = "Trending in \(category)"
            self.collectionView.reloadData()
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
                    self.trendingNowLbl.text = "Trending in \(category)"
                    downloadCoverImage(coverImageID: "\(coverID)", targetImageView: self.trendingBookCover, placeholderImage: UIImage(resource: .placeholder))
                    UIView.animate(withDuration: 1.5, delay: 0.5, options: [.curveEaseIn], animations: {
                        self.trendingBookCover.alpha = 1.0
                        self.trendingBookTitle.alpha = 1.0
                        self.trendingNowLbl.alpha = 1.0
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
                        self.trendingNowLbl.text = "Trending Now"
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .clear
        
        var borderColor = UIColor.clear.cgColor
        let borderWidth: CGFloat = 2
        
        if indexPath == selectedIndexPath{
            borderColor = UIColor(resource: .brandPurple).cgColor
        }else{
            borderColor = UIColor.greenSea.cgColor
        }
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height))
        label.textAlignment = .center
        label.clipsToBounds = true
        label.textColor = UIColor(resource: .textBG)
        label.backgroundColor = UIColor(resource: .background)
        label.layer.borderWidth = borderWidth
        label.layer.borderColor = borderColor
        label.layer.cornerRadius = 15
        label.text = bookCategories[indexPath.item]
        cell.contentView.addSubview(label)
        cell.clipsToBounds = true
        
        return cell
    }
    
}
