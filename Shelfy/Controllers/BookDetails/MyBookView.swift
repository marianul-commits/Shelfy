//
//  MyBookView.swift
//  Shelfy
//
//  Created by Marian Nasturica on 16.03.2024.
//

import UIKit
import CoreData
import NotificationBannerSwift
import SkeletonView
import Cosmos


class MyBookView: UIViewController {
    
    //Segue Values
    var bookID: String?
    var bookImg: String?
    var bookTitle: String?
    var bookPages: String?
    var bookAuthor: String?
    
    var bImage = makeImgView(withImage: "placeholder")
    var bAuthor = UILabel()
    let bookRating = CosmosView()
    var trackBtn = UIButton()
    var progressBar = makeProgressBar()
    var progressLbl = makeLabel(withText: "          ")
    lazy var bTitle = UILabel()
    var shareBtn = UIButton()
    var container = UIView()
    var pagesRead: Int?
    var totalPages = 0
    var btnStack = makeStackView(withOrientation: .horizontal, withSpacing: 3)
    var isPercentageDisplay = false // Flag to track whether percentage or pages read is displayed
    
    //Core Data Stack
    var bookArray = [BookItem]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMyBookView()
        
    }
    
    func setupMyBookView() {
        
        progressLbl.isSkeletonable = true
        progressLbl.showAnimatedSkeleton()
        progressLbl.linesCornerRadius = 5
        
        self.bTitle.text = self.bookTitle!
        self.bAuthor.text = self.bookAuthor
        if let coverID = self.bookImg {
            downloadCoverImage(coverImageID: "\(coverID)", targetImageView: self.bImage, placeholderImage: UIImage(resource: .placeholder))
            
        }
        bImage.contentMode = .scaleAspectFit
        
        
        // Check Core Data for the number of pages first
        if let bookItem = fetchBookItem(forTitle: bTitle.text!) {
            if let totalPagesString = bookItem.bookTotalPages, let totalPagesInt = Int(totalPagesString), totalPagesInt != 0 {
                // Core Data has total pages, proceed with the existing logic
                self.totalPages = totalPagesInt
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.progressBar.layer.sublayers?.forEach({ $0.removeAllAnimations() })
                    self.progressBar.progress = 0
                    self.progressLbl.hideSkeleton(transition: .crossDissolve(0.25))
                    self.progressLbl.text = "\(self.pagesRead!) / \(self.totalPages) pages"
                    UIView.animate(withDuration: 1.5, delay: 0, options: [.curveEaseInOut], animations: {
                        let prgrs = self.calculateProgress(pagesRead: self.pagesRead!, totalPages: self.totalPages)
                        self.progressBar.setProgress(prgrs, animated: true)
                    })
                }
            } else {
                // Core Data does not have total pages, perform API call to fetch
                fetchNumberOfPages(forTitle: bTitle.text!) { numberOfPages in
                    if let numberOfPages = numberOfPages, numberOfPages != 0 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            self.progressBar.layer.sublayers?.forEach({ $0.removeAllAnimations() })
                            self.progressLbl.hideSkeleton(transition: .crossDissolve(0.25))
                            self.totalPages = numberOfPages
                            self.progressLbl.text = "\(self.pagesRead!) / \(self.totalPages) pages"
                            UIView.animate(withDuration: 1.5, delay: 0, options: [.curveEaseInOut], animations: {
                                let prgrs = self.calculateProgress(pagesRead: self.pagesRead!, totalPages: self.totalPages)
                                self.progressBar.setProgress(prgrs, animated: true)
                            })

                            // Update bookTotalPages in Core Data
                            if let bookItem = self.fetchBookItem(forTitle: self.bTitle.text!) {
                                bookItem.bookTotalPages = "\(numberOfPages)"
                                do {
                                    try self.context.save()
                                } catch {
                                    print("Error saving bookTotalPages: \(error)")
                                }
                            } else {
                                print("Book item not found.")
                            }

                            print("Number of pages: \(numberOfPages)")
                        }
                    } else {
                        DispatchQueue.main.async {
                            print("Failed to fetch number of pages or received 0")
                            // Prompt the user to input the total number of pages
                            let alertController = UIAlertController(title: "Enter Total Pages", message: "Please enter the total number of pages for the book:", preferredStyle: .alert)
                            alertController.addTextField { textField in
                                textField.placeholder = "Total Pages"
                                textField.keyboardType = .numberPad
                            }
                            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                                // Retrieve the input from the text field
                                if let textField = alertController.textFields?.first, let text = textField.text, let total = Int(text), total != 0 {
                                    // Update the total pages with the user input
                                    self.totalPages = total
                                    if let bookItem = self.fetchBookItem(forTitle: self.bTitle.text!) {
                                        bookItem.bookTotalPages = "\(total)"
                                        do {
                                            try self.context.save()
                                        } catch {
                                            print("Error saving bookTotalPages: \(error)")
                                        }
                                    } else {
                                        print("Book item not found.")
                                    }
                                }
                            }
                            alertController.addAction(cancelAction)
                            alertController.addAction(okAction)
                            // Present the alert controller
                            self.present(alertController, animated: true, completion: nil)
                        }

                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            self.progressLbl.hideSkeleton(transition: .crossDissolve(0.25))
                            self.progressLbl.text = "\(self.pagesRead!) / \(self.totalPages) pages"
                            UIView.animate(withDuration: 1.5, delay: 0, options: [.curveEaseInOut], animations: {
                                let prgrs = self.calculateProgress(pagesRead: self.pagesRead!, totalPages: self.totalPages)
                                self.progressBar.setProgress(prgrs, animated: true)
                            })
                        }
                    }
                }
            }
        }

        //Book Ratings API Call
        fetchBookRatings(forKey: bookID!) { ratings in
            DispatchQueue.main.async {
                if let ratings = ratings, let averageRating = ratings.summary?.average {
                    self.bookRating.text = String(format: "%.1f", averageRating)
                    self.bookRating.rating = averageRating
                } else {
                    self.bookRating.text = "0"
                    self.bookRating.rating = 0.0
                }
            }
        }
        
        //Rating Setup
        bookRating.translatesAutoresizingMaskIntoConstraints = false
        bookRating.settings.fillMode = .precise
        bookRating.settings.emptyBorderColor = UIColor(resource: .brandMint)
        bookRating.settings.emptyColor = UIColor(resource: .brandMint)
        bookRating.settings.filledColor = UIColor(resource: .brandDarkMint)
        bookRating.settings.filledBorderColor = UIColor(resource: .brandDarkMint)
        bookRating.settings.textColor = UIColor(resource: .textBG)
        bookRating.settings.textFont = SetFont.setFontStyle(.regular, 12)
        bookRating.isUserInteractionEnabled = false
        
        //Progress Bar Setup
        let progressValue = calculateProgress(pagesRead: pagesRead!, totalPages: totalPages)
        let progressLblValue = calculateProgress(pagesRead: pagesRead!, totalPages: totalPages) * 100
        progressBar.progress = progressValue
        progressBar.setProgress(calculateProgress(pagesRead: pagesRead!, totalPages: totalPages), animated: true)
        
        //Progress Lbl Setup
        progressLbl.text = String(format: "%.0f%%", progressLblValue)
        progressBar.tintColor = UIColor(resource: .brandPurple)
        progressBar.trackTintColor = UIColor(resource: .brandDarkPurple)
        progressBar.progressViewStyle = .bar
        progressBar.layer.cornerRadius = 2
        progressBar.clipsToBounds = true
        
        //Book Title Setup
        bTitle.translatesAutoresizingMaskIntoConstraints = false
        bTitle.contentMode = .center
        bTitle.textAlignment = .center
        bTitle.lineBreakMode = .byTruncatingTail
        bTitle.numberOfLines = 1
        bTitle.font = SetFont.setFontStyle(.medium, 16)
        
        //Book Author Setup
        bAuthor.translatesAutoresizingMaskIntoConstraints = false
        bAuthor.contentMode = .center
        bAuthor.textAlignment = .center
        bAuthor.lineBreakMode = .byTruncatingTail
        bAuthor.numberOfLines = 1
        bAuthor.font = SetFont.setFontStyle(.regular, 14)
        
        //Track Button Setup
        trackBtn.translatesAutoresizingMaskIntoConstraints = false
        trackBtn.setTitle(" Flip & Track", for: .normal)
        trackBtn.setImage(UIImage(systemName: "book.pages"), for: .normal)
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.filled()
            config.cornerStyle = .capsule
            config.contentInsets = NSDirectionalEdgeInsets(top: 9, leading: 6, bottom: 9, trailing: 6)
            config.baseBackgroundColor = UIColor(resource: .brandPurple)
            trackBtn.configuration = config
            trackBtn.addTarget(self, action: #selector(trackPages), for: .touchUpInside)
        } else {
            trackBtn.layer.cornerRadius = 20
            trackBtn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
            trackBtn.backgroundColor = UIColor(resource: .brandPurple)
            trackBtn.tintColor = .black
            trackBtn.addTarget(self, action: #selector(trackPages), for: .touchUpInside)
        }
        
        //Share Button Setup
        shareBtn.setTitle(" Share", for: .normal)
        shareBtn.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.filled()
            config.cornerStyle = .capsule
            config.contentInsets = NSDirectionalEdgeInsets(top: 9, leading: 6, bottom: 9, trailing: 6)
            config.baseBackgroundColor = UIColor(resource: .disabled)
            shareBtn.configuration = config
            shareBtn.addTarget(self, action: #selector(share), for: .touchUpInside)
        } else {
            shareBtn.layer.cornerRadius = 20
            shareBtn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
            shareBtn.backgroundColor = UIColor(resource: .disabled)
            shareBtn.tintColor = .black
            shareBtn.addTarget(self, action: #selector(share), for: .touchUpInside)
        }
        
        //Container Setup
        container.translatesAutoresizingMaskIntoConstraints = false
        container.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        K.setGradientBackground(view: container, colorTop: UIColor(resource: .brandMint), colorBottom: UIColor(resource: .brandYellow))
        container.layer.cornerRadius = 12
        container.clipsToBounds = true
        
        
        
        view.addSubview(btnStack)
        view.addSubview(bookRating)
        btnStack.addArrangedSubview(trackBtn)
        btnStack.addArrangedSubview(shareBtn)
        view.addSubview(trackBtn)
        view.addSubview(bImage)
        view.addSubview(bTitle)
        view.addSubview(bAuthor)
        view.addSubview(container)
        container.addSubview(progressBar)
        container.addSubview(progressLbl)
        
        // Have the image size scale per device screen
        let imageWidthPercentage: CGFloat = 0.5
        let imageHeightPercentage: CGFloat = 0.4
        let imageWidthConstant = UIScreen.main.bounds.width * imageWidthPercentage
        let imageHeightConstant = UIScreen.main.bounds.height * imageHeightPercentage
        
        NSLayoutConstraint.activate([
            
            bImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            bImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            bImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            bImage.widthAnchor.constraint(equalToConstant: imageWidthConstant),
            bImage.heightAnchor.constraint(equalToConstant: imageHeightConstant),
            
            bTitle.topAnchor.constraint(equalTo: bImage.bottomAnchor, constant: 12),
            bTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            bTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            bAuthor.topAnchor.constraint(equalTo: bTitle.bottomAnchor, constant: 8),
            bAuthor.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            bAuthor.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            bookRating.topAnchor.constraint(equalTo: bAuthor.bottomAnchor, constant: 8),
            bookRating.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            container.topAnchor.constraint(equalTo: btnStack.bottomAnchor, constant: 36),
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            container.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
            
            progressLbl.bottomAnchor.constraint(equalTo: progressBar.topAnchor, constant: -12),
            progressLbl.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            
            progressBar.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            progressBar.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
            progressBar.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -24),
            
            btnStack.topAnchor.constraint(equalTo: bookRating.bottomAnchor, constant: 24),
            btnStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            btnStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            trackBtn.leadingAnchor.constraint(equalTo: btnStack.leadingAnchor),
            trackBtn.widthAnchor.constraint(equalTo: btnStack.widthAnchor, multiplier: 0.45),
            
            shareBtn.widthAnchor.constraint(equalTo: btnStack.widthAnchor, multiplier: 0.45),
            shareBtn.centerYAnchor.constraint(equalTo: trackBtn.centerYAnchor),
            
        ])
        
        
    }
    
    @objc func trackPages() {
        // Create an alert controller
        let alertController = UIAlertController(title: "Add Pages", message: nil, preferredStyle: .alert)
        
        // Add a text field
        alertController.addTextField { (textField) in
            textField.placeholder = "How many pages have you read?"
            textField.keyboardType = .numberPad // Set keyboard type to number pad
        }
        
        // Add actions
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            // Retrieve text from the text field
            if let textField = alertController.textFields?.first, let text = textField.text, let pagesToAdd = Int(text) {
                // Calculate pages read
                let newPagesRead: Int
                if self.pagesRead == 0 {
                    newPagesRead = max(pagesToAdd, 0) // Ensure pagesRead doesn't go below 0
                } else {
                    newPagesRead = max(self.pagesRead! + pagesToAdd, 0) // Ensure pagesRead doesn't go below 0
                }
                
                // Check if pages read exceed total pages
                if newPagesRead > self.totalPages {
                    // Display error message if pages read exceed total pages
                    let errorController = UIAlertController(title: "Error", message: K.addPagesError, preferredStyle: .alert)
                    errorController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(errorController, animated: true, completion: nil)
                } else {
                    // Update pages read and progress bar if valid
                    self.pagesRead = newPagesRead
                    let progressValue = self.calculateProgress(pagesRead: self.pagesRead!, totalPages: self.totalPages)
                    self.progressBar.progress = progressValue
                    self.progressLbl.text = "\(self.pagesRead!) / \(self.totalPages) pages"
                    if let bookItem = self.fetchBookItem(forTitle: self.bTitle.text!) {
                        bookItem.bookPages = "\(self.pagesRead!)"
                        do {
                            try self.context.save()
                        } catch {
                            print("Error saving book: \(error)")
                        }
                    }
                }
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }
    
    func fetchBookItem(forTitle title: String) -> BookItem? {
        let fetchRequest: NSFetchRequest<BookItem> = BookItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "bookTitle == %@", title)
        
        do {
            let fetchedItems = try context.fetch(fetchRequest)
            return fetchedItems.first
        } catch {
            print("Error fetching book item: \(error)")
            return nil
        }
    }
    
    
    func fetchPages() {
        let fetchRequest: NSFetchRequest<BookItem> = BookItem.fetchRequest()
        do {
            // Fetch the BookItem from Core Data
            let bookItems = try context.fetch(fetchRequest)
            // Assuming you want to work with the first fetched BookItem
            if let firstBookItem = bookItems.first {
                // Access the bookPages attribute and assign it to pagesRead
                pagesRead = Int(firstBookItem.bookPages!)
                self.progressBar.progress = calculateProgress(pagesRead: pagesRead!, totalPages: self.totalPages)
            } else {
                // Handle the case where no BookItem is found
                print("No BookItem found")
            }
        } catch {
            // Handle fetch errors
            print("Error fetching BookItem: \(error.localizedDescription)")
        }
    }
    
    @objc func share(sender: UIButton) {
        let bookT = "I tracked my progress for \(bookTitle!) on Shelfy, Check it out!"
        guard let bookURL = URL(string: "https://openlibrary.org/search?q=\(bookTitle!)") else {
            return
        }
        
        let activityViewController = UIActivityViewController(activityItems: [bookT, bookURL], applicationActivities: nil)
        
        let navigationController = UINavigationController(rootViewController: activityViewController)
        navigationController.modalPresentationStyle = .formSheet // Adjust as per your requirement
        
        present(navigationController, animated: true, completion: nil)
    }
    
    
    func loadBooks() {
        
        let request: NSFetchRequest<BookItem> = BookItem.fetchRequest()
        do {
            bookArray = try context.fetch(request)
        } catch {
            print("error loading: \(error)")
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
    
    func updateProgressLabel() {
        if let pagesRead = pagesRead {
            if isPercentageDisplay {
                let percentage = Int(Double(pagesRead) / Double(totalPages) * 100)
                progressLbl.text = "\(percentage)%"
            } else {
                progressLbl.text = "\(pagesRead) / \(totalPages) pages"
            }
        } else {
            // Handle the case where pagesRead is nil
            progressLbl.text = "N/A"
        }
    }
    
}
