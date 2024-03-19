//
//  BookView.swift
//  Shelfy
//
//  Created by Marian Nasturica on 11.06.2023.
//

import UIKit
import Cosmos
import CoreData
import NotificationBannerSwift

class BookView: UIViewController, UIScrollViewDelegate, ChidoriDelegate {
    
    //MARK: - Page Elements
    
    //Categories
    var itemArray = [BookItem]()
    
    var selectedCategory : BookCategory? {
        didSet{
            loadItems()
        }
    }
    
    var selectedCategories: [BookCategory] = [] {
        didSet {
            loadItems() // Assuming you want to load items for all categories
        }
    }

    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    //Main Elements
    let bookImg = makeImgView(withImage: "placeholder")
    let bookTitle = makeLabel(withText: "Title")
    let bookAuthor = makeLabel(withText: "Author")
    let container = makeView()

    //Ratings
    let rating = CosmosView()

    //Book Stats
    let bookStats = makeStackView(withOrientation: .horizontal, withSpacing: 3)
    let bookDoneStack = makeStackView(withOrientation: .vertical, withSpacing: 1)
    let bookReadingStack = makeStackView(withOrientation: .vertical, withSpacing: 1)
    let bookToReadStack = makeStackView(withOrientation: .vertical, withSpacing: 1)
    var bkDoneImg = UIImageView()
    var bkToReadImg = UIImageView()
    var bkReadingImg = UIImageView()
    var bkDone = makeLabel(withText: "")
    var bkToRead = makeLabel(withText: "")
    var bkReading = makeLabel(withText: "")
    var bkDoneLbl = makeLabel(withText: "")
    var bkToReadLbl = makeLabel(withText: "")
    var bkReadingLbl = makeLabel(withText: "")

    //Description
    let descrHeader = makeLabel(withText: "Description")
    let descrContent = makeLabel(withText: "")
    
    //More By Author
    let moreByHeader = makeLabel(withText: "More by author")
    let moreCollection = makeCollectionView()
    
    
    //Screen Separation
    let topView = TopView()
    let bottomView = BottomView()
    let stackView = makeStackView(withOrientation: .vertical, withSpacing: 5.0)
    
    //Bottom View Pagination
    let pageControl = UIPageControl()
    let numberOfPages = 2
    var previousPage: Int = 0
    
    //Add to button
    var actionMappings: [UIAction.Identifier: UIActionHandler] = [:]
    let addToShelfyImg = UIImage(systemName: "books.vertical")
    let addToReadImg = UIImage(systemName: "book.closed")
    let shareBtn = UIImage(systemName: "square.and.arrow.up")
    var addButton = UIButton(type: .custom)
    
    //MARK: - Segue Values
    
    var bTitle: String?
    var bAuthor: String?
    var bImage: Int?
    var bDescr: String?
    var bookID: String?

    
    var recommendedBooks = [OLBook]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //MARK: -  API Calls
        
        //More By Author
        getRecommandationz( bAuthor! ) { (recommendedBooks) in
            guard let similarBooks = recommendedBooks else {
                print("Error fetching books")
                return
            }
            DispatchQueue.main.async {
                self.recommendedBooks = similarBooks
                self.moreCollection.reloadData()
            }
        }
        
        //Book Description
        fetchBookDescription(forKey: bookID!) { description in
            DispatchQueue.main.async {
                if let description = description {
                    self.descrContent.text = description
                } else {
                    self.descrContent.text = "Description not available"
                }
            }
        }
        
        //Book Ratings
        fetchBookRatings(forKey: bookID!) { ratings in
            DispatchQueue.main.async {
                if let ratings = ratings, let averageRating = ratings.summary?.average {
                    self.rating.text = String(format: "%.1f", averageRating)
                    self.rating.rating = averageRating
                } else {
                    self.rating.text = "0"
                    self.rating.rating = 0.0
                }
            }
        }
        
        //Book Stats
        fetchBookShelves(forKey: bookID!) { shelves in
            DispatchQueue.main.async {
                if let shelves = shelves, let counts = shelves.counts {
                    self.bkDone.text = String(counts.already_read!)
                    self.bkReading.text = String(counts.currently_reading!)
                    self.bkToRead.text = String(counts.want_to_read!)
                } else {
                    self.bkDone.text = "0"
                    self.bkReading.text = "0"
                    self.bkToRead.text = "0"
                }
            }
        }
        
        //Categories
        fetchCategories()
        
        
        //MARK:  Collection View
        moreCollection.dataSource = self
        moreCollection.delegate = self
        moreCollection.register(MoreByCell.self, forCellWithReuseIdentifier: "testIdentifier")
        

        
        setupBookView()
        
        
        
    }
    
    
    //MARK: - Setup View
    func setupBookView() {
        
        view.backgroundColor = UIColor(resource: .background)
        
        container.backgroundColor = UIColor(resource: .brandPurple)
        container.layer.cornerRadius = 16

        //MARK: Book Image
        
        bookImg.contentMode = .scaleAspectFit
        
        if let coverImage = bImage {
            let imageURLString = "https://covers.openlibrary.org/b/id/\(coverImage)-M.jpg"
            if let imageURL = URL(string: imageURLString) {
                URLSession.shared.dataTask(with: imageURL) { data, response, error in
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.bookImg.image = image
                        }
                    }else {
                        // If the book has no photo, set a placeholder image
                        DispatchQueue.main.async {
                            self.bookImg.image = UIImage(named: "placeholder")
                        }
                    }
                }.resume()
            }
        }
        
        //MARK: Book Title
        
        bookTitle.text = bTitle
        bookTitle.font = SetFont.setFontStyle(.regular, 16)
        bookTitle.textColor = UIColor(resource: .textBG)
        bookTitle.numberOfLines = 1
        bookTitle.lineBreakMode = .byTruncatingTail
        
        //MARK: Book Author
        
        bookAuthor.text = bAuthor
        bookAuthor.font = SetFont.setFontStyle(.regular, 14)
        bookAuthor.numberOfLines = 1
        bookAuthor.lineBreakMode = .byTruncatingTail
        bookAuthor.textColor = UIColor(resource: .textBG)
        
        //MARK: Book Description
        
        descrContent.text = bDescr
        descrHeader.font = SetFont.setFontStyle(.medium, 16)
        descrHeader.textColor = UIColor(resource: .textBG)
        descrContent.font = SetFont.setFontStyle(.regular, 14)
        descrContent.textColor = UIColor(resource: .textBG)
        
        //MARK: Ratings
        
        rating.translatesAutoresizingMaskIntoConstraints = false
        rating.settings.fillMode = .precise
        rating.settings.emptyBorderColor = UIColor(resource: .brandMint)
        rating.settings.emptyColor = UIColor(resource: .brandMint)
        rating.settings.filledColor = UIColor(resource: .brandDarkMint)
        rating.settings.filledBorderColor = UIColor(resource: .brandDarkMint)
        rating.settings.textColor = UIColor(resource: .textBG)
        rating.settings.textFont = SetFont.setFontStyle(.regular, 12)
        rating.isUserInteractionEnabled = false
        
        //MARK: Book Stats
        
        bookStats.distribution = .equalCentering
        bookDoneStack.distribution = .fillEqually
        bookReadingStack.distribution = .fillEqually
        bookToReadStack.distribution = .fillEqually
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(stackTapped))
        bookStats.addGestureRecognizer(tapGesture)
        bookStats.isUserInteractionEnabled = true
        
        bkDoneImg.translatesAutoresizingMaskIntoConstraints = false
        bkDone.translatesAutoresizingMaskIntoConstraints = false
        bkDoneLbl.translatesAutoresizingMaskIntoConstraints = false
        bkDone.font = SetFont.setFontStyle(.regular, 14)
        bkDone.textAlignment = .center
        bkDoneLbl.font = SetFont.setFontStyle(.regular, 14)
        bkDoneLbl.textAlignment = .center
        bkDoneLbl.isHidden = true
        bkDoneLbl.text = "Read"
        bkDoneImg.image = UIImage(systemName: "book.closed")
        bkDoneImg.contentMode = .scaleAspectFit
        bkDoneImg.tintColor = UIColor(resource: .brandDarkPurple)
        
        bkToReadImg.translatesAutoresizingMaskIntoConstraints = false
        bkToRead.translatesAutoresizingMaskIntoConstraints = false
        bkToReadLbl.translatesAutoresizingMaskIntoConstraints = false
        bkToRead.font = SetFont.setFontStyle(.regular, 14)
        bkToRead.textAlignment = .center
        bkToReadLbl.font = SetFont.setFontStyle(.regular, 14)
        bkToReadLbl.textAlignment = .center
        bkToReadLbl.isHidden = true
        bkToReadLbl.text = "To Read"
        bkToReadImg.image = UIImage(systemName: "bookmark")
        bkToReadImg.contentMode = .scaleAspectFit
        bkToReadImg.tintColor = UIColor(resource: .brandDarkPurple)
        
        bkReadingImg.translatesAutoresizingMaskIntoConstraints = false
        bkReading.translatesAutoresizingMaskIntoConstraints = false
        bkReadingLbl.translatesAutoresizingMaskIntoConstraints = false
        bkReading.font = SetFont.setFontStyle(.regular, 14)
        bkReading.textAlignment = .center
        bkReadingLbl.font = SetFont.setFontStyle(.regular, 14)
        bkReadingLbl.textAlignment = .center
        bkReadingLbl.isHidden = true
        bkReadingLbl.text = "Reading"
        bkReadingImg.image = UIImage(systemName: "book")
        bkReadingImg.contentMode = .scaleAspectFit
        bkReadingImg.tintColor = UIColor(resource: .brandDarkPurple)
        
        //MARK: More By Author

        moreByHeader.font = SetFont.setFontStyle(.medium, 16)
        moreByHeader.textColor = UIColor(resource: .textBG)

        //MARK: - Book Scroll View
        let screenBound = UIScreen.main.bounds
        let middleX = screenBound.width / 2
        let middleY = screenBound.height / 2
        let scrollViewHeight: CGFloat = pageControl.currentPage == 0 ? screenBound.height * 0.5 : screenBound.height
        
        let bookSV = UIScrollView(frame: CGRect(x: middleX, y: middleY, width: screenBound.width, height: scrollViewHeight))
        bookSV.translatesAutoresizingMaskIntoConstraints = false
        bookSV.contentSize = CGSize(width: screenBound.width * 2, height: screenBound.height)
        bookSV.isPagingEnabled = true
        bookSV.alwaysBounceVertical = false
        bookSV.showsVerticalScrollIndicator = false
        bookSV.showsHorizontalScrollIndicator = false
        disableVerticalScroll(bookSV)
        bookSV.layer.cornerRadius = bookSV.frame.size.height / 45
        bookSV.delegate = self
        
        //MARK: - Add Button Config
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.setImage(UIImage(systemName: "plus"), for: .normal)
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.filled()
            config.cornerStyle = .capsule
            config.contentInsets = NSDirectionalEdgeInsets(top: 7, leading: 5, bottom: 7, trailing: 5)
            config.baseBackgroundColor = UIColor(resource: .brandPurple)
            addButton.configuration = config
            addButton.addTarget(self, action: #selector(tapped(button:)), for: .touchUpInside)
        } else {
            addButton.layer.cornerRadius = 20
            addButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
            addButton.backgroundColor = UIColor(resource: .brandPurple)
            addButton.tintColor = .black
            addButton.addTarget(self, action: #selector(tapped(button:)), for: .touchUpInside)
        }
        
        
        //MARK: - Creating Scroll View subviews
        let descrView = UIView(frame: CGRect(x: 0, y: 0, width: screenBound.width, height: screenBound.height))
        descrView.translatesAutoresizingMaskIntoConstraints = false
        descrView.backgroundColor = UIColor(resource: .brandMint)
        descrView.layer.cornerRadius = descrView.frame.size.height / 45
        
        let moreByView = UIView(frame: CGRect(x: screenBound.width, y: 0, width: screenBound.width, height: screenBound.height))
        moreByView.translatesAutoresizingMaskIntoConstraints = false
        moreByView.backgroundColor = UIColor(resource: .brandMint)
        moreByView.layer.cornerRadius = moreByView.frame.size.height / 45
        
        //MARK: - Page Control
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = numberOfPages
        pageControl.currentPage = 0
        pageControl.isUserInteractionEnabled = false
        pageControl.currentPageIndicatorTintColor = UIColor(.white)
        pageControl.pageIndicatorTintColor = UIColor(resource: .brandGray)
        
        //MARK: Adding the elements to the view
        stackView.addArrangedSubview(topView)
        stackView.addArrangedSubview(bottomView)
        
        
        bookStats.addArrangedSubview(bookDoneStack)
        bookDoneStack.addArrangedSubview(bkDoneLbl)
        bookDoneStack.addArrangedSubview(bkDoneImg)
        bookDoneStack.addArrangedSubview(bkDone)
        
        bookStats.addArrangedSubview(bookReadingStack)
        bookReadingStack.addArrangedSubview(bkReadingLbl)
        bookReadingStack.addArrangedSubview(bkReadingImg)
        bookReadingStack.addArrangedSubview(bkReading)
        
        bookStats.addArrangedSubview(bookToReadStack)
        bookToReadStack.addArrangedSubview(bkToReadLbl)
        bookToReadStack.addArrangedSubview(bkToReadImg)
        bookToReadStack.addArrangedSubview(bkToRead)
        
        topView.addSubview(bookImg)
        topView.addSubview(addButton)
        container.addSubview(bookTitle)
        container.addSubview(bookAuthor)
        container.addSubview(rating)
        
        bottomView.addSubview(bookSV)
        bottomView.addSubview(pageControl)
        
        bookSV.addSubview(descrView)
        descrView.addSubview(bookStats)
        descrView.addSubview(descrHeader)
        descrView.addSubview(descrContent)
        bookSV.addSubview(moreByView)
        moreByView.addSubview(moreByHeader)
        moreByView.addSubview(moreCollection)
        
        view.addSubview(stackView)
        view.addSubview(container)
        view.bringSubviewToFront(container)
        
        topView.bringSubviewToFront(bookStats)
        topView.bringSubviewToFront(addButton)
        
        
        // Have the image size scale per device screen
        let imageWidthPercentage: CGFloat = 0.5
        let imageHeightPercentage: CGFloat = 0.4
        
        let screenSize = UIScreen.main.bounds
        let safeArea = view.safeAreaLayoutGuide
        
        let imageWidthConstant = UIScreen.main.bounds.width * imageWidthPercentage
        let imageHeightConstant = UIScreen.main.bounds.height * imageHeightPercentage
        
        let maxWidth = UIScreen.main.bounds.width - 45
        
        let widthAnch = bookTitle.widthAnchor.constraint(equalToConstant: bookTitle.intrinsicContentSize.width)
        
        NSLayoutConstraint.activate([
            
            //MARK: Top View Constraints
            
            //Book Image
            bookImg.topAnchor.constraint(equalTo: topView.safeAreaLayoutGuide.topAnchor, constant: 12),
            bookImg.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            bookImg.widthAnchor.constraint(equalToConstant: imageWidthConstant),
            bookImg.heightAnchor.constraint(equalToConstant: imageHeightConstant),
            
            //Add button
            addButton.topAnchor.constraint(greaterThanOrEqualTo: bookImg.topAnchor, constant: 12),
            addButton.trailingAnchor.constraint(equalTo: bookImg.trailingAnchor, constant: 48),
            
            //Container
            container.bottomAnchor.constraint(equalTo: bookImg.bottomAnchor),
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            container.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.1),
            //Title
            bookTitle.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
            bookTitle.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            bookTitle.widthAnchor.constraint(lessThanOrEqualToConstant: maxWidth),
            //Author
            bookAuthor.topAnchor.constraint(equalTo: bookTitle.bottomAnchor, constant: 5),
            bookAuthor.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            bookAuthor.widthAnchor.constraint(lessThanOrEqualToConstant: maxWidth),
            bookAuthor.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8),
            //Ratings
            rating.topAnchor.constraint(equalTo: container.bottomAnchor, constant: 8),
            rating.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            //Stats
            bookStats.topAnchor.constraint(equalTo: bookSV.topAnchor, constant: 10),
            bookStats.leadingAnchor.constraint(equalTo: bookSV.leadingAnchor, constant: 16),
            bookStats.trailingAnchor.constraint(equalTo: moreByView.leadingAnchor, constant: -16),
            
            topView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            topView.widthAnchor.constraint(equalTo: view.widthAnchor),
            bottomView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            bottomView.widthAnchor.constraint(equalTo: view.widthAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            //MARK: Bottom View Constraints
            
            bookSV.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 40),
            bookSV.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 15),
            bookSV.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -15),
            bookSV.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: 5),
            
            //MARK: Description View Constraints
            
            descrView.topAnchor.constraint(equalTo: bookSV.topAnchor),
            descrView.leadingAnchor.constraint(equalTo: bookSV.leadingAnchor),
            descrView.trailingAnchor.constraint(equalTo: moreByView.leadingAnchor),
            descrView.widthAnchor.constraint(equalTo: bookSV.widthAnchor),
            descrView.bottomAnchor.constraint(equalTo: bookSV.bottomAnchor, constant: -8),
            
            descrHeader.topAnchor.constraint(equalTo: bookStats.bottomAnchor, constant: 15),
            descrHeader.centerXAnchor.constraint(equalTo: descrView.centerXAnchor),
            
            descrContent.topAnchor.constraint(equalTo: descrHeader.bottomAnchor, constant: 8),
            descrContent.leadingAnchor.constraint(equalTo: descrView.leadingAnchor,constant: 15),
            descrContent.trailingAnchor.constraint(equalTo: descrView.trailingAnchor, constant: -15),
            descrContent.bottomAnchor.constraint(equalTo: descrView.bottomAnchor, constant: -15),
            
            //MARK: More View Constraints
            
            moreByView.topAnchor.constraint(equalTo: bookSV.topAnchor),
            moreByView.leadingAnchor.constraint(equalTo: descrView.trailingAnchor),
            moreByView.widthAnchor.constraint(equalTo: bookSV.widthAnchor),
            moreByView.trailingAnchor.constraint(equalTo: bookSV.trailingAnchor),
            moreByView.heightAnchor.constraint(equalTo: moreCollection.heightAnchor, multiplier: 1.25),
            
            moreByHeader.topAnchor.constraint(equalTo: moreByView.topAnchor, constant: 15),
            moreByHeader.centerXAnchor.constraint(equalTo: moreByView.centerXAnchor),
            
            moreCollection.topAnchor.constraint(equalTo: moreByHeader.bottomAnchor, constant: 5),
            moreCollection.leadingAnchor.constraint(equalTo: moreByView.leadingAnchor, constant: 5),
            moreCollection.trailingAnchor.constraint(equalTo: moreByView.trailingAnchor, constant: -5),
            moreCollection.bottomAnchor.constraint(equalTo: moreByView.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            
            //MARK: Page Control Constraints
            
            pageControl.bottomAnchor.constraint(equalTo: bottomView.safeAreaLayoutGuide.bottomAnchor, constant: 4),
            pageControl.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor),
            
        ])
    }
    
    @objc func stackTapped() {
        bkDoneLbl.isHidden = !bkDoneLbl.isHidden
        bkToReadLbl.isHidden = !bkToReadLbl.isHidden
        bkReadingLbl.isHidden = !bkReadingLbl.isHidden
    }
    
    
    //MARK: - Categories function

    func fetchCategories() {
        let fetchRequest: NSFetchRequest<BookCategory> = BookCategory.fetchRequest()
        do {
            let categories = try managedObjectContext.fetch(fetchRequest)
            selectedCategories = categories // Update selectedCategories to be an array of BookCategory
        } catch {
            print("Error fetching categories: \(error.localizedDescription)")
        }
    }

    
    
    //MARK: - Add Button functions
    
    func didSelectAction(_ action: UIAction) {
        actionMappings[action.identifier]?(action)
    }
    
    @objc private func tapped(button: UIButton) {
        
        let tappedPoint = CGPoint(x: addButton.center.x, y: addButton.frame.maxY + addButton.frame.height)
        
        let chidoriMenu = ChidoriMenu(menu: sampleMenu, summonPoint: tappedPoint)
        chidoriMenu.delegate = self
        present(chidoriMenu, animated: true, completion: nil)
    }
    
    private lazy var sampleMenu: UIMenu = {
        var postActions: [UIAction] = []
        
        let addToShelfyIdentifier = UIAction.Identifier("addShelfy")
        actionMappings[addToShelfyIdentifier] = shelfy(action:)
        let addToShelfyAction = UIAction(title: "Add To Shelfy", image: addToShelfyImg?.withRenderingMode(.alwaysTemplate), identifier: addToShelfyIdentifier, handler: read(action:))
        postActions.append(addToShelfyAction)
        
        let addToReadIdentifier = UIAction.Identifier("haveRead")
        actionMappings[addToReadIdentifier] = read(action:)
        let addToReadAction = UIAction(title: "Already Read", image: addToReadImg?.withRenderingMode(.alwaysTemplate), identifier: addToReadIdentifier, handler: share(action:))
        postActions.append(addToReadAction)
        
        let shareBtnIdentifier = UIAction.Identifier("wishlist")
        actionMappings[shareBtnIdentifier] = share(action:)
        let shareBtnAction = UIAction(title: "Share", image: shareBtn?.withRenderingMode(.alwaysTemplate), identifier: shareBtnIdentifier, handler: placeholder(action:))
        postActions.append(shareBtnAction)
        
        let postMenu = UIMenu(title: "Test Test", image: nil, identifier: nil, options: [], children: postActions)
        
        return postMenu
    }()
    
    func placeholder(action: UIAction) {
        print("Save called")
    }
    
    func shelfy(action: UIAction) {
        // Dismiss the currently presented view controller if any
        dismiss(animated: true) {
            // Once dismissed, present the UIAlertController
            let alertController = UIAlertController(title: "Select the Shelfy you wish to add this to", message: "", preferredStyle: .actionSheet)
            
            // Add actions for each category starting from the second one
            for categoryIndex in 1..<self.selectedCategories.count {
                let category = self.selectedCategories[categoryIndex]
                let action = UIAlertAction(title: category.name ?? "Unknown Category", style: .default) { [weak self] _ in
                    self?.addToShelfy(category: category)
                }
                alertController.addAction(action)
            }
            
            // Add cancel action
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            // Present the alert controller
            self.present(alertController, animated: true, completion: nil)
        }
    }

    
    func addToShelfy(category: BookCategory) {
        
        let successBanner = FloatingNotificationBanner(
            title: "Success",
            subtitle: "Book added to \(category.name!)",
            style: .success)
        
        successBanner.show(bannerPosition: .bottom, edgeInsets: UIEdgeInsets(top: 2, left: 5, bottom: 2, right: 5), cornerRadius: 12)
        
        do {
            let newBook = BookItem(context: managedObjectContext)
            newBook.bookTitle = bTitle
            newBook.bookDescription = bDescr
            newBook.bookAuthor = bAuthor
            newBook.bookCover = "\(bImage!)"
            newBook.bookKey = bookID
            newBook.parentCategory = category
            
            try managedObjectContext.save()
        } catch {
            print("error saving \(error)")
            let errorBanner = FloatingNotificationBanner(
                title: "Error",
                subtitle: "Could not add book to category, \(error)",
                style: .success)
            
            successBanner.show(bannerPosition: .bottom, edgeInsets: UIEdgeInsets(top: 2, left: 5, bottom: 2, right: 5), cornerRadius: 12)
            
        }
    }

    func read(action: UIAction) {
        // Dismiss the currently presented view controller if any
        dismiss(animated: true) {
            // Find the "Read" category
            if let readCategory = self.selectedCategories.first(where: { $0.name == "Read Books" }) {
                // Add the book item to the "Read" category
                self.addToRead(category: readCategory)
                let successBanner = FloatingNotificationBanner(
                    title: "Success",
                    subtitle: "Book added to read books",
                    style: .success)
                
                successBanner.show(bannerPosition: .bottom, edgeInsets: UIEdgeInsets(top: 2, left: 5, bottom: 2, right: 5), cornerRadius: 12)
            } else {
                let errorBanner = FloatingNotificationBanner(
                    title: "Error",
                    subtitle: "Could not find 'Read Books' category",
                    style: .warning)
                
                errorBanner.show(bannerPosition: .bottom, edgeInsets: UIEdgeInsets(top: 2, left: 5, bottom: 2, right: 5), cornerRadius: 12)
            }
        }
    }
    
    func addToRead(category: BookCategory) {
        do {
            try managedObjectContext.save()

        } catch {
            print("error saving \(error)")

        }
    }
    
    @objc func share(action: UIAction) {
        guard let bookURL = URL(string: "https://openlibrary.org\(bookID!)") else {
            // Handle invalid URL
            return
        }
        
        dismiss(animated: true) {
            let activityViewController = UIActivityViewController(activityItems: [bookURL], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
        }
    }

    //MARK: Update Page Control
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.bounds.width
        let currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = currentPage
        
        if currentPage != previousPage {
            let newXOffset = CGFloat(currentPage) * scrollView.bounds.width
            UIView.animate(withDuration: 0.5) {
                scrollView.contentOffset = CGPoint(x: newXOffset, y: 0)
            }
        }
    }
    
    //MARK: Disable Vertical Scroll in paginated Scroll View
    func disableVerticalScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 {
            scrollView.contentOffset.y = 0
        }
        if scrollView.contentOffset.y < 0 {
            scrollView.contentOffset.y = 0
        }
    }
    
    //MARK: CoreData
    
    func saveItems() {
        do{
            try managedObjectContext.save()
        } catch {
            print("error saving context \(error)")
        }
    }
    
    func loadItems(with request: NSFetchRequest<BookItem> = BookItem.fetchRequest(), predicate: NSPredicate? = nil) {
        
        guard let selectedCategory = selectedCategory else {
            print("Error: selectedCategory is nil")
            return
        }
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        do{
            itemArray = try managedObjectContext.fetch(request)
        } catch {
            print("error fetching \(error)")
        }
    }
    
}

//MARK: - Collection View Extensions

extension BookView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recommendedBooks.count
    }
    
    // Configure the cells
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "testIdentifier", for: indexPath) as! MoreByCell
        // Customize the cell's content based on the data
        cell.titleLabel?.text = recommendedBooks[indexPath.row].title
        
        if let coverURL = recommendedBooks[indexPath.row].cover_i {
            let imageURLString = "https://covers.openlibrary.org/b/id/\(coverURL)-M.jpg"
            if let imageURL = URL(string: imageURLString) {
                URLSession.shared.dataTask(with: imageURL) { data, response, error in
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            cell.imageView?.image = image
                        }
                    } else {
                        // If the book has no photo or there was an error downloading the image, set a placeholder image
                        DispatchQueue.main.async {
                            cell.imageView?.image = UIImage(named: "placeholder")
                        }
                    }
                    
                }.resume()
            }
        }
        
        return cell
    }
    
}
