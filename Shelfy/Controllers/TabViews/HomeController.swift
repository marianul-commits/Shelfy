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
    
    //Reading Goal View
    
    var readingGoalPB = makeProgressBar()
    var readingGoalView = makeView()
    var monthLbl = makeLabel(withText: "")
    var readingGoalPBLabel = makeLabel(withText: "")
    var readingGoalLbl = makeLabel(withText: "Reading Goal")
    var currentMonth: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: Date())
    }
    //Trending Now View
    
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
    
    //Continue Tracking View

    var continueReadingContainer = UIView()
    var continueHeader = makeLabel(withText: "Continue tracking")
    var continueSubtitle = makeLabel(withText: "Ready to dive back in?")
    var continueProgressBar = UIProgressView()
    var continueProgressLbl = UILabel()
    var continueBookPhoto = UIImageView()
    lazy var continueTotalPgs = 0
    lazy var continueReadPgs = 0
    
    //MARK: View Will Appear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Selecting Random Genre
        while randomGenre == nil {
            randomGenre = K.topGenres.randomElement()
        }
        //API Call
        pickRandomBook(fromGenre: "\(randomGenre!)") { title, coverID, authorName, bookKey in
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
    } //End viewWillAppear
    
    //MARK: View Did Appear
    
    override func viewDidAppear(_ animated: Bool) {
        
        getAllBookPages() //Core Data Call for bookPages & bookTotalPages values
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            
            let intBooks = self.bookPages.map { Int($0) ?? 0 }
            let intTotalPages = self.bookTotalPages.map { Int($0) ?? 0 }
            let pagesRead = intBooks.reduce(0, +)
            let totalPages = intTotalPages.reduce(0, +)
            self.readingGoalPB.setProgress(self.calculateProgress(pagesRead: pagesRead, totalPages: totalPages), animated: true)
            var progressLblValue = self.calculateProgress(pagesRead: pagesRead, totalPages: totalPages) * 100
            self.readingGoalPBLabel.text = String(format: "%.0f%%", progressLblValue)
            
        } // Setting the values for ProgressBar.progress
        
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
        setupView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
        DispatchQueue.main.async { //Hiding the current values to better display new ones upon coming back
            
            self.trendingBookCover.alpha = 0.0
            self.trendingBookTitle.alpha = 0.0
            self.trendingBookAuthor.alpha = 0.0
            self.errorLbl.alpha = 0.0
            
        }
    }
    
    func setupView() {
        
        let intBooks = self.bookPages.map { Int($0) ?? 0 }
        let intTotalPages = self.bookTotalPages.map { Int($0) ?? 0 }
        
        
        let pagesRead = intBooks.reduce(0, +)
        let totalPages = intTotalPages.reduce(0, +)
                
        let safeArea = view.safeAreaLayoutGuide
        
        trendingBookCover.alpha = 0.0
        trendingBookTitle.alpha = 0.0
        trendingBookAuthor.alpha = 0.0
        errorLbl.alpha = 0.0
        
        header.text = "Hot in \(randomGenre!)"
        
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
        
        
        trendingView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        K.setGradientBackground(view: trendingView, colorTop: UIColor(resource: .brandPurple), colorBottom: UIColor(resource: .brandPink))
        trendingBCPlaceholder.skeletonCornerRadius = 10
        
        let seeBook = UITapGestureRecognizer(target: self, action: #selector(bookTapped))
        trendingView.addGestureRecognizer(seeBook)
        
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
        
        stackView.alignment = .center
        
        
        continueBookPhoto.image = UIImage(resource: .placeholder)
        
        fetchLastAccessedBook() //Core Data call to last accessed book using bookLastAccesed
        
        continueReadingContainer.translatesAutoresizingMaskIntoConstraints = false
        continueHeader.translatesAutoresizingMaskIntoConstraints = false
        continueSubtitle.translatesAutoresizingMaskIntoConstraints = false
        continueProgressBar.translatesAutoresizingMaskIntoConstraints = false
        continueProgressLbl.translatesAutoresizingMaskIntoConstraints = false
        continueBookPhoto.translatesAutoresizingMaskIntoConstraints = false
        
        continueProgressBar.progress = 0
        continueProgressBar.tintColor = UIColor(resource: .brandPink)
        continueProgressBar.trackTintColor = UIColor(resource: .brandDarkPurple)
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
        K.setGradientBackground(view: continueReadingContainer, colorTop: UIColor(resource: .brandYellow), colorBottom: UIColor(resource: .brandMint))

        
        continueBookPhoto.clipsToBounds = true
        continueBookPhoto.layer.cornerRadius = 16
        
        
        view.addSubview(trendingView)
        trendingView.addSubview(trendingBookCover)
        trendingView.addSubview(trendingBCPlaceholder)
        trendingView.addSubview(trendingBookTitle)
        trendingView.addSubview(header)
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
        
        let continueImgWidthPercent: CGFloat = 0.16
        let continueImgHeightPercent: CGFloat = 0.21
        
        let continueImgWidthConstant = UIScreen.main.bounds.width * continueImgWidthPercent
        let continueImgHeightConstant = UIScreen.main.bounds.height * continueImgHeightPercent
        
        readingGoalView.backgroundColor = UIColor(resource: .brandMint)
        readingGoalView.layer.cornerRadius = 12
        monthLbl.text = currentMonth
        monthLbl.font = SetFont.setFontStyle(.medium, 18)
        readingGoalLbl.font = SetFont.setFontStyle(.medium, 22)
        
        var progressValue = calculateProgress(pagesRead: pagesRead, totalPages: totalPages)
        var progressLblValue = calculateProgress(pagesRead: pagesRead, totalPages: totalPages) * 100
        readingGoalPB.setProgress(calculateProgress(pagesRead: pagesRead, totalPages: totalPages), animated: true)
        
        readingGoalPBLabel.text = String(format: "%.0f%%", progressLblValue)
        readingGoalPB.tintColor = UIColor(resource: .brandPurple)
        readingGoalPB.trackTintColor = UIColor(resource: .brandDarkPurple)
        readingGoalPB.progressViewStyle = .bar
        readingGoalPB.layer.cornerRadius = 2
        readingGoalPB.clipsToBounds = true
        
        trendingBTPlaceholder.isSkeletonable = true
        trendingBCPlaceholder.isSkeletonable = true
        
        view.addSubview(readingGoalView)
        view.addSubview(readingGoalLbl)
        view.addSubview(trendingNowLbl)
        readingGoalView.addSubview(monthLbl)
        readingGoalView.addSubview(readingGoalPB)
        readingGoalView.addSubview(readingGoalPBLabel)
        
        NSLayoutConstraint.activate([
            readingGoalLbl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            readingGoalLbl.leadingAnchor.constraint(equalTo: readingGoalView.leadingAnchor),
            readingGoalView.topAnchor.constraint(equalTo: readingGoalLbl.bottomAnchor, constant: 12),
            readingGoalView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            readingGoalView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            readingGoalView.widthAnchor.constraint(equalTo: safeArea.widthAnchor, constant: -30),
            readingGoalView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.15),
            monthLbl.topAnchor.constraint(equalTo: readingGoalView.topAnchor, constant: 20),
            monthLbl.leadingAnchor.constraint(equalTo: readingGoalView.leadingAnchor, constant: 20),
            readingGoalPB.leadingAnchor.constraint(equalTo: readingGoalView.leadingAnchor, constant: 20),
            readingGoalPB.trailingAnchor.constraint(equalTo: readingGoalView.trailingAnchor, constant: -20),
            readingGoalPB.heightAnchor.constraint(equalToConstant: 4),
            readingGoalPB.bottomAnchor.constraint(equalTo: readingGoalView.bottomAnchor, constant: -15),
            readingGoalPBLabel.bottomAnchor.constraint(equalTo: readingGoalPB.topAnchor, constant: -6),
            readingGoalPBLabel.leadingAnchor.constraint(equalTo: readingGoalView.leadingAnchor, constant: 20),
            
            trendingNowLbl.topAnchor.constraint(equalTo: readingGoalView.bottomAnchor, constant: 24),
            trendingNowLbl.leadingAnchor.constraint(equalTo: trendingView.leadingAnchor),
            
            trendingView.topAnchor.constraint(equalTo: trendingNowLbl.bottomAnchor, constant: 12),
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
            
            continueReadingContainer.topAnchor.constraint(equalTo: trendingView.bottomAnchor, constant: 24),
            continueReadingContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            continueReadingContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            continueReadingContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15),
            
            continueBookPhoto.topAnchor.constraint(equalTo: continueReadingContainer.topAnchor, constant: 4),
            continueBookPhoto.trailingAnchor.constraint(equalTo: continueReadingContainer.trailingAnchor, constant: -4),
            continueBookPhoto.bottomAnchor.constraint(equalTo: continueReadingContainer.bottomAnchor, constant: -4),
            continueBookPhoto.widthAnchor.constraint(equalToConstant: continueImgWidthConstant),
            continueBookPhoto.heightAnchor.constraint(lessThanOrEqualToConstant: continueImgHeightConstant),
            
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
    
    func fetchLastAccessedBook() {
        let fetchRequest: NSFetchRequest<BookItem> = BookItem.fetchRequest()
        
        // Sort the fetch request by lastAccessedDate in descending order
        let sortDescriptor = NSSortDescriptor(key: "bookLastAccessed", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Limit the fetch request to return only the last item
        fetchRequest.fetchLimit = 1
        
        do {
            let result = try context.fetch(fetchRequest)
            
            for item in result {
                DispatchQueue.main.async {
                    // Update UI elements with information from the fetched items
                    let coverID = item.bookCover
                    
                    let totalPgsString = item.bookTotalPages
                    let totalPgsInt = Int(totalPgsString ?? "0")
                    
                    let readPgsString = item.bookPages
                    let readPgsInt = Int(readPgsString ?? "0")
                    
                    // Assuming these properties are part of your view controller
                    self.continueTotalPgs = totalPgsInt ?? 0
                    self.continueReadPgs = readPgsInt ?? 0

                    self.continueProgressBar.progress = self.calculateProgress(pagesRead: self.continueReadPgs, totalPages: self.continueTotalPgs)
                    
                    downloadCoverImage(coverImageID: "\(coverID!)", targetImageView: self.continueBookPhoto, placeholderImage: UIImage(resource: .placeholder))
                    self.continueProgressLbl.text = "Page \(self.continueReadPgs) of \(self.continueTotalPgs)"
                    
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
    
}


