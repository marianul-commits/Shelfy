//
//  SearchController.swift
//  Shelfy
//
//  Created by Marian Nasturica on 05.06.2023.
//

import UIKit
import Vision

class SearchView: UIViewController, UITableViewDelegate, UISearchControllerDelegate {
    
    let searchController = UISearchController(searchResultsController: nil)
    var displayBooks: [Items] = []
    let searchTable = makeTableView()
    var bookTitle: String!
    var bookAuth: [String]!
    var bookDescr: String!
    var bookImg: String!
    var bookRtg: Double?
    var foundISBN: String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        
        // Setting up navigation controller
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationItem.searchController = searchController
        
        // Setting up search bar & delegates
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchTable.delegate = self
        searchTable.dataSource = self
        
        // Creating cell
        searchTable.register(UINib(nibName: K.cellNibName2, bundle: nil), forCellReuseIdentifier: K.cellIdentifier2)
        
        // API Call
        fetchBooks { (books) in
            guard let books = books else {
                print("Error fetching books")
                return
            }
            
            DispatchQueue.main.async {
                self.displayBooks = books
                self.searchTable.reloadData()
            }
        }
        
        setupSearchV()
    }
    
    func setupSearchV() {
        
        //MARK: Adding the elements to the view
        
        searchTable.backgroundColor = UIColor.clear
        
        searchController.searchBar.placeholder = "Search Books, Authors, ISBN"
        searchController.searchBar.tintColor = UIColor(named: "Color1")
        
        view.addSubview(searchTable)
        
        searchTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        searchTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        searchTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        searchTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15).isActive = true
    }
}

//MARK: - SearchBar Extension
extension SearchView: UISearchBarDelegate {
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        var searchTerm = ""
        searchTerm = searchController.searchBar.text!
        self.displayBooks = []
        
        fetchSearch("\(searchTerm)") { (searchBooks) in
            guard let books = searchBooks else {
                print("Error fetching books")
                return
            }
            DispatchQueue.main.async {
                self.displayBooks = books
                self.searchTable.reloadData()
            }
        }
        
        searchController.searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchController.searchBar.text = ""
        searchController.searchBar.placeholder = "Search Books, Authors, ISBN"
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.searchBar.text = ""
        searchController.searchBar.placeholder = "Search Books, Authors, ISBN"
    }
    
}

//MARK: - TableView Extension
extension SearchView: UITableViewDataSource {
    
    // Disable table view scrolling when the data source is empty
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if displayBooks.isEmpty {
            scrollView.isScrollEnabled = false
        } else {
            scrollView.isScrollEnabled = true
        }
    }
    
    
    func tableView(_ searchTable: UITableView, numberOfRowsInSection section: Int) -> Int {
        if displayBooks.count == 0 {
            self.searchTable.setEmptyMessage(EmptyTable.searchMsg.randomElement()!)
        }else{
            self.searchTable.restore()
        }
        return displayBooks.count
    }
    
    func tableView(_ searchTable: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        searchTable.deselectRow(at: indexPath, animated: true)
        
        bookTitle = displayBooks[indexPath.row].volumeInfo.title
        bookAuth = displayBooks[indexPath.row].volumeInfo.authors
        bookDescr = displayBooks[indexPath.row].volumeInfo.description
        bookImg = displayBooks[indexPath.row].volumeInfo.imageLinks?.thumbnail
        bookRtg = displayBooks[indexPath.row].volumeInfo.averageRating
        
        // Show the detail view controller
        let detailVC = BookView()
        detailVC.bTitle = bookTitle
        detailVC.author = bookAuth?.joined(separator: ", ") ?? "N/A"
        detailVC.descr = bookDescr
        detailVC.avgRating = bookRtg
        if let imageURLString = bookImg,
           let imageURL = URL(string: imageURLString) {
            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: imageURL),
                   let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        detailVC.bookImg.image = image
                    }
                }
            }
        } else {
            // If the book has no photo, set a placeholder image
            detailVC.bookImg.image = UIImage(named: "placeholder")
        }
        present(detailVC, animated: true, completion: nil)
    }
    
    func tableView(_ searchTable: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTable.dequeueReusableCell(withIdentifier: K.cellIdentifier2, for: indexPath) as! MyBooksCell
        
        cell.clipsToBounds = true
        cell.backgroundColor = .clear
        
        let bookz = displayBooks[indexPath.row]
        
        cell.MBTitle?.text = bookz.volumeInfo.title
        cell.MBDescr?.text = bookz.volumeInfo.description
        // Setting the cell author label from the API
        if let author = bookz.volumeInfo.authors {
            cell.MBAuthor?.text = (author.joined(separator: ", ")) ?? "N/A"
        }
        // Setting the cell image from the API
        if let imageURLString = bookz.volumeInfo.imageLinks?.thumbnail,
           let imageURL = URL(string: imageURLString) {
            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: imageURL),
                   let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        cell.MBPhoto?.image = image
                    }
                }
            }
        } else {
            // If the book has no photo, set a placeholder image
            cell.MBPhoto?.image = UIImage(named: "placeholder")
        }
        
        return cell
    }
    
}
