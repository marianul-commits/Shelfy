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
    let test = UIView()
    let listTable = UITableView()
//    var searchController = UISearchController(searchResultsController: nil)
    var addButton = UIButton()
    var backBtn = UIButton(type: .custom)
    
    let header = makeLabel(withText: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupListView()
        
    }
    
    func setupListView() {
            
        listTable.translatesAutoresizingMaskIntoConstraints = false
        
        test.translatesAutoresizingMaskIntoConstraints = false
        
        header.text = selectedCategory?.name
        header.font = SetFont.setFontStyle(.medium, 22)
        
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
        
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        backBtn.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backBtn.setTitle(" Back", for: .normal)
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.filled()
            config.cornerStyle = .capsule
            config.contentInsets = NSDirectionalEdgeInsets(top: 7, leading: 5, bottom: 7, trailing: 5)
            config.baseBackgroundColor = UIColor(resource: .brandLogo3)
            backBtn.configuration = config
            backBtn.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        } else {
            backBtn.layer.cornerRadius = 20
            backBtn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
            backBtn.backgroundColor = UIColor(resource: .brandLogo3)
            backBtn.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        }
        
        
        view.addSubview(listTable)
        view.addSubview(backBtn)
        view.addSubview(header)
        
        NSLayoutConstraint.activate([
            
            backBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            backBtn.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            
            header.centerYAnchor.constraint(equalTo: backBtn.centerYAnchor),
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            header.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            listTable.topAnchor.constraint(equalTo: backBtn.bottomAnchor, constant: 12),
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
    
    @objc func dismissView() {
        // Dismiss the current view controller with a transition
        dismiss(animated: true, completion: nil)
    }
    
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("error saving \(error)")
        }
        
        listTable.reloadData()
        
    }
    
    
    func loadItems(with request: NSFetchRequest<BookItem> = BookItem.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        do{
            bookItems = try context.fetch(request)
        } catch {
            print("error fetching \(error)")
        }
        listTable.reloadData()
    }
    
}

extension MyBooksCentralView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ searchTable: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard (bookItems.count != 0) else {
            self.listTable.setEmptyMessage(EmptyTable.collectionMsg.randomElement()!)
            return 0
        }
        self.listTable.restore()
        return bookItems.count
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
    
        if bookItems.count != 0 {
            
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
                downloadCoverImage(coverImageID: "\(coverID)", targetImageView: cell.MBPhoto, placeholderImage: UIImage(resource: .placeholder))
            }
        }
        return cell
    }
    
    
    func tableView(_ searchTable: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        searchTable.deselectRow(at: indexPath, animated: true)
        
        var selectedBook = bookItems[indexPath.row]

        // Show the detail view controller
        let detailVC = MyBookView()
        
        detailVC.bookTitle = selectedBook.bookTitle
        detailVC.bookAuthor = selectedBook.bookAuthor
        detailVC.bookImg = selectedBook.bookCover
        detailVC.pagesRead = Int(selectedBook.bookPages ?? "0")
        detailVC.bookID = selectedBook.bookKey
        detailVC.view.backgroundColor = UIColor(resource: .background)
        detailVC.modalPresentationStyle = .popover
        
        present(detailVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            // Handle the deletion
            self.deleteCategory(at: indexPath)
            completionHandler(true)
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        
        deleteAction.backgroundColor = .red
        
        // Return the actions configuration
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }

    func deleteCategory(at indexPath: IndexPath) {
        // Perform deletion logic here
        context.delete(bookItems[indexPath.row])
        bookItems.remove(at: indexPath.row)
        self.listTable.deleteRows(at: [indexPath], with: .fade)
        saveItems()
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
