//
//  MyBooksCentralView.swift
//  Shelfy
//
//  Created by Marian Nasturica on 02.07.2023.
//

import UIKit
import CoreData

class MyBooksCentralView: UIViewController {
    
    var bookItems = [BookItem]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedCategory: BookCategory? {
        didSet {
            loadItems()
        }
    }
    let listTable = UITableView()
//    var searchController = UISearchController(searchResultsController: nil)
    var addButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupListView()
        
    }
    
    func setupListView() {
            
        listTable.translatesAutoresizingMaskIntoConstraints = false
        
        listTable.backgroundColor = .clear
        listTable.delegate = self
        listTable.dataSource = self
        listTable.register(UINib(nibName: K.cellNibName2, bundle: nil), forCellReuseIdentifier: K.cellIdentifier2)
        listTable.isSkeletonable = true
        
        //Search Controller
//        searchController.delegate = self
//        searchController.searchBar.delegate = self
//        navigationController?.setNavigationBarHidden(true, animated: true)
//        navigationItem.searchController = searchController
//        searchController.hidesNavigationBarDuringPresentation = false
//        searchController.searchBar.tintColor = UIColor(resource: .brandMint)
        
        view.addSubview(listTable)
        
        NSLayoutConstraint.activate([
            
            listTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            listTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            listTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            listTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),
  
            
        ])
        
//        addButton.translatesAutoresizingMaskIntoConstraints = false
//        addButton.setImage(UIImage(systemName: "plus"), for: .normal)
//        if #available(iOS 15.0, *) {
//            var config = UIButton.Configuration.filled()
//            config.cornerStyle = .capsule
//            config.contentInsets = NSDirectionalEdgeInsets(top: 7, leading: 5, bottom: 7, trailing: 5)
//            config.baseBackgroundColor = UIColor(resource: .brandPurple)
//            addButton.configuration = config
////            addButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
//        } else {
//            addButton.layer.cornerRadius = 20
//            addButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
//            addButton.backgroundColor = UIColor(resource: .brandPurple)
//            addButton.tintColor = .black
////            addButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
//        }
        
        
        
    }
    
    func loadItems() {
        
        let request: NSFetchRequest<BookItem> = BookItem.fetchRequest()
        do {
            bookItems = try context.fetch(request)
        } catch {
            print("error loading: \(error)")
        }
        
    }
    
}

extension MyBooksCentralView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ searchTable: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard (bookItems.count != 0) else {
            return 0
        }
        return bookItems.count
        
        }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if bookItems.isEmpty {
            scrollView.isScrollEnabled = false
        } else {
            scrollView.isScrollEnabled = true
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Apply inset constraints
        let verticalPadding: CGFloat = 8
        
        let maskLayer = CALayer()
        maskLayer.cornerRadius = 10
        maskLayer.backgroundColor = UIColor.white.cgColor
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 4, dy: verticalPadding/2)
        cell.layer.mask = maskLayer
    }
    
    func tableView(_ searchTable: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTable.dequeueReusableCell(withIdentifier: K.cellIdentifier2, for: indexPath) as! MyBooksCell
    
        if bookItems != nil {
            
            cell.hideAnimation()
            
            let bookz = bookItems[indexPath.row]
            
            cell.MBTitle?.text = bookz.bookTitle
            cell.MBTitle.font = SetFont.setFontStyle(.medium, 16)
            cell.MBAuthor?.text = bookz.bookAuthor
            cell.MBAuthor.font = SetFont.setFontStyle(.medium, 16)
            fetchBookDescription(forKey: bookz.bookKey!) { description in
                DispatchQueue.main.async {
                    if let description = description {
                        cell.MBDescr.text = description
                    } else {
                        cell.MBDescr.text = "Description not available"
                    }
                }
            }
            cell.MBDescr.font = SetFont.setFontStyle(.regular, 14)
            // Setting the cell image from the API
            if let coverID = bookz.bookCover {
                let imageURLString = "https://covers.openlibrary.org/b/id/\(coverID)-M.jpg"
                if let imageURL = URL(string: imageURLString) {
                    URLSession.shared.dataTask(with: imageURL) { data, response, error in
                        if let data = data, let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                cell.MBPhoto?.image = image
                            }
                        } else {
                            // If the book has no photo or there was an error downloading the image, set a placeholder image
                            DispatchQueue.main.async {
                                cell.MBPhoto?.image = UIImage(named: "placeholder")
                            }
                        }
                        
                    }.resume()
                }
                
            }
        }
        return cell
    }
    
    func tableView(_ searchTable: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        searchTable.deselectRow(at: indexPath, animated: true)
        
        var selectedBook = bookItems[indexPath.row]

        // Show the detail view controller
        let detailVC = BookView()
        
        detailVC.bookID = selectedBook.bookKey
        detailVC.bTitle = selectedBook.bookTitle
        detailVC.bAuthor = selectedBook.bookAuthor
        detailVC.bImage = Int(selectedBook.bookCover!)
        
        
        
        if let coverID = selectedBook.bookCover {
            let imageURLString = "https://covers.openlibrary.org/b/id/\(coverID)-M.jpg"
            if let imageURL = URL(string: imageURLString) {
                URLSession.shared.dataTask(with: imageURL) { data, response, error in
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            detailVC.bookImg.image = image
                        }
                    } else {
                        // If the book has no photo, set a placeholder image
                        detailVC.bookImg.image = UIImage(named: "placeholder")
                    }
                    
                }.resume()
                
                present(detailVC, animated: true, completion: nil)
            }
        }
    }
    
}

//extension MyBooksCentralView: UISearchControllerDelegate, UISearchBarDelegate {
//    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        var searchTerm = ""
//        searchTerm = searchController.searchBar.text!
////        self.books = []
////        
////        searchBookz("\(searchTerm)") { (searchBooks) in
////            guard let books = searchBooks else {
////                print("Error fetching books")
////                return
////            }
////            DispatchQueue.main.async {
////                self.books = books
////                self.searchTable.reloadData()
////            }
////        }
//        
//        searchController.searchBar.resignFirstResponder()
//    }
//    
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        searchController.searchBar.text = ""
//        searchController.searchBar.placeholder = "Search Books, Authors, ISBN"
//    }
//    
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        searchController.searchBar.text = ""
//        searchController.searchBar.placeholder = "Search Books, Authors, ISBN"
//    }
//    
//}
