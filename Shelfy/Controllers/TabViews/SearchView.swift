//
//  SearchController.swift
//  Shelfy
//
//  Created by Marian Nasturica on 05.06.2023.
//

import UIKit

class SearchView: UIViewController {
    
    //MARK: Creating values
    
    var searchController = UISearchController(searchResultsController: nil)
    var books: [OLBook]?
    var searchTable = UITableView()
    var cellNumbers = 10
    
    //Creating Segue Values
    var bookTitle: String!
    var bookAuthor: String!
    var bookCover: Int?
    var bookKey: String?
    var bookISBN: String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchView()
        
        fetchBookz { (books) in
            guard let books = books else {
                print("Error fetching books")
                DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                    UIView.animate(withDuration: 1.5, delay: 0.5, options: [.curveEaseIn], animations: {
                        self.cellNumbers = 0
                        self.searchTable.reloadData()
                        self.searchTable.setEmptyMessage(EmptyTable.searchMsg.randomElement()!)
                    }, completion: nil)
                }
                return
            }
            
            DispatchQueue.main.async {
                self.books = books
                self.searchTable.reloadData()
            }
        }
        
    }
    
    func setupSearchView() {
        
        searchTable.translatesAutoresizingMaskIntoConstraints = false
        searchController.searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        //Table
        
        searchTable.backgroundColor = .clear
        searchTable.delegate = self
        searchTable.dataSource = self
        searchTable.register(UINib(nibName: K.cellNibName2, bundle: nil), forCellReuseIdentifier: K.cellIdentifier2)
        searchTable.isSkeletonable = true
        
        //Search Controller
        searchController.delegate = self
        searchController.searchBar.delegate = self
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationItem.searchController = searchController
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.tintColor = UIColor(resource: .brandMint)
        
        //Adding them to view
        
        view.addSubview(searchTable)
    
        //Constraints
        
        NSLayoutConstraint.activate([
            
            searchTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            searchTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            searchTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            searchTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),
  
            
        ])
        
    }
    
    
}

//MARK: - TableView Extension
extension SearchView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ searchTable: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return books?.count ?? cellNumbers
        
        }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if books!.isEmpty {
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
            
        if books != nil {
            
            cell.hideAnimation()
            
            let bookz = books![indexPath.row]
            
            cell.MBTitle?.text = bookz.title
            cell.MBTitle.font = SetFont.setFontStyle(.medium, 16)
            // Setting the cell author label from the API
            if let author = bookz.author_name?.first {
                cell.MBAuthor?.text = author
            }
            cell.MBAuthor.font = SetFont.setFontStyle(.medium, 16)
            fetchBookDescription(forKey: bookz.key) { description in
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
            if let coverID = bookz.cover_i {
                downloadCoverImage(coverImageID: "\(coverID)", targetImageView: cell.MBPhoto, placeholderImage: UIImage(resource: .placeholder))
            }
        }
        return cell
    }
    
    func tableView(_ searchTable: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        searchTable.deselectRow(at: indexPath, animated: true)
                
        let selectedBook = books![indexPath.row]
        
        bookTitle = selectedBook.title
        bookAuthor = selectedBook.author_name?.first
        bookKey = selectedBook.key
        bookCover = selectedBook.cover_i
        
        // Show the detail view controller
        let detailVC = BookView()
        
        detailVC.bookID = bookKey
        detailVC.bTitle = bookTitle
        detailVC.bAuthor = bookAuthor
        detailVC.bImage = bookCover
        
        
        
        if let coverID = selectedBook.cover_i {
            downloadCoverImage(coverImageID: "\(coverID)", targetImageView: detailVC.bookImg, placeholderImage: UIImage(resource: .placeholder))
                
                present(detailVC, animated: true, completion: nil)
            }
    }
}

//MARK: - Search Controller Extension
extension SearchView: UISearchControllerDelegate, UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        var searchTerm = ""
        searchTerm = searchController.searchBar.text!
        self.books = []
        
        searchBookz("\(searchTerm)") { (searchBooks) in
            guard let books = searchBooks else {
                print("Error fetching books")
                return
            }
            DispatchQueue.main.async {
                self.books = books
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
