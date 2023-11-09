//
//  MyBooksController.swift
//  Shelfy
//
//  Created by Marian Nasturica on 05.06.2023.
//

import UIKit

class MyBooksController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var myBooksTable: UITableView!
    @IBOutlet weak var segCtrl: UISegmentedControl!
    
    var searcBar: UISearchBar!
    var filter: [String]!
    var isThisOn = true
    var books: [Items] = []
    var bookTitle: String!
    var bookAuth: [String]!
    var bookDescr: String!
    var bookImg: String!
    var bookRtg: Double?
    var bookID: String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myBooksTable.delegate = self
        myBooksTable.dataSource = self
        myBooksTable.register(UINib(nibName: K.cellNibName2, bundle: nil), forCellReuseIdentifier: K.cellIdentifier2)
        myBooksTable.backgroundColor = UIColor.clear
        myBooksTable.layer.backgroundColor = UIColor.clear.cgColor
        // Segment Control Customization
        segCtrl.setTitleTextAttributes([NSAttributedString.Key.font: SetFont.setFontStyle(.regular, 16)], for: .selected)
        segCtrl.setTitleTextAttributes([NSAttributedString.Key.font: SetFont.setFontStyle(.mono, 16)], for: .normal)
        segCtrl.setTitleTextAttributes([.foregroundColor: UIColor(named: "Accent5")!], for: .normal)
        segCtrl.setTitleTextAttributes([.foregroundColor: UIColor(named: "Accent6")!], for: .selected)
        // Search Bar as Table View header customization
        searcBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: myBooksTable.frame.width, height: 50))
        searcBar.delegate = self
        searcBar.placeholder = "Find books"
        searcBar.backgroundColor = UIColor.clear
        searcBar.searchBarStyle = .minimal
        searcBar.tintColor = UIColor(named: "Color1")!
        searcBar.isHidden = books.count <= 15
        myBooksTable.tableHeaderView = searcBar
        // API Call
        fetchBooks { (books) in
            guard let books = books else {
                print("Error fetching books")
                return
            }
            
            DispatchQueue.main.async {
                self.books = books
                self.myBooksTable.reloadData()
            }
        }
        
    }
    @IBAction func segCtrlClick(_ sender: Any) {
        switch segCtrl.selectedSegmentIndex{
        case 0:
            isThisOn = true
            myBooksTable.reloadData()
        case 1:
            isThisOn = false
            myBooksTable.reloadData()
        default:
            isThisOn = true
        }
    }
    
}




//MARK: - SearchBar Extension

extension MyBooksController: UISearchBarDelegate {
    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        filter = []
//        if searchText == ""
//        {
//            filter =
//        }
//
//        for word in testData{
//            if word.uppercased().contains(searchText.uppercased()){
//                filter.append(word)
//            }
//        }
//        self.myBooksTable.reloadData()
//    }
    
}


//MARK: - TableView Extension

extension MyBooksController: UITableViewDataSource {
    
    func tableView(_ myBooksTable: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if isThisOn == true{
            if books.count == 0 {
                self.myBooksTable.setEmptyMessage(EmptyTable.shelfMsg.randomElement()!)
            }else{
                self.myBooksTable.restore()
            }
            return books.count
            //        } else {
            //            if testData2.count == 0 {
            //                self.myBooksTable.setEmptyMessage(EmptyTable.shelfMsg.randomElement()!)
            //            }else{
            //                self.myBooksTable.restore()
            //            }
            //            return testData2.count
            //        }
        }
        
        // Disable table view scrolling when the data source is empty
        func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
            if isThisOn == true {
                if books.isEmpty {
                    scrollView.isScrollEnabled = false
                } else {
                    scrollView.isScrollEnabled = true
                }
            }
            //        else {
            //            if testData2.isEmpty {
            //                scrollView.isScrollEnabled = false
            //            } else {
            //                scrollView.isScrollEnabled = true
            //            }
            //        }
        }
        
        func tableView(_ myBooksTable: UITableView, didSelectRowAt indexPath: IndexPath) {
            myBooksTable.deselectRow(at: indexPath, animated: true)
            
            if isThisOn == true {
                bookID = books[indexPath.row].id
                bookTitle = books[indexPath.row].volumeInfo.title
                bookAuth = books[indexPath.row].volumeInfo.authors
                bookDescr = books[indexPath.row].volumeInfo.description
                bookImg = books[indexPath.row].volumeInfo.imageLinks?.thumbnail
                bookRtg = books[indexPath.row].volumeInfo.averageRating
                
                performSegue(withIdentifier: "MyBookTransition", sender: self)
                print("Data Set 1")
            } else {
                print("Data Set 2")
            }
        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MyBookTransition" {
            if let bookviewVC = segue.destination as? BookView {
                print("Preparing for segue with book: \(bookTitle)")

                bookviewVC.bTitle = bookTitle
                bookviewVC.author = bookAuth?.joined(separator: ", ") ?? "N/A"
                bookviewVC.descr = bookDescr
                bookviewVC.avgRating = bookRtg
                bookviewVC.bookID = bookID
                if let imageURLString = bookImg,
                   let imageURL = URL(string: imageURLString) {
                    DispatchQueue.global().async {
                        if let imageData = try? Data(contentsOf: imageURL),
                           let image = UIImage(data: imageData) {
                            DispatchQueue.main.async {
                                bookviewVC.bookImg.image = image
                            }
                        }
                    }
                } else {
                    // If the book has no photo, set a placeholder image
                    bookviewVC.bookImg.image = UIImage(named: "placeholder")
                }
            }
        }
    }
    
    func tableView(_ myBooksTable: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = myBooksTable.dequeueReusableCell(withIdentifier: K.cellIdentifier2, for: indexPath) as! MyBooksCell
        
        cell.clipsToBounds = true
        cell.backgroundColor = .clear
        cell.isUserInteractionEnabled = true
        
        let bookz = books[indexPath.row]
        
        // Data Set 1 enabled
        if isThisOn == true {
            
            cell.MBTitle?.text = bookz.volumeInfo.title
            cell.MBDescr?.text = bookz.volumeInfo.description
            // Setting the cell author label from the API
            let author = bookz.volumeInfo.authors
            cell.MBAuthor?.text = (author?.joined(separator: ", ")) ?? "N/A"
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
          
            // Data Set 2 enabled
        } else {
            cell.MBTitle?.text = bookz.volumeInfo.title
            if let author = bookz.volumeInfo.authors {
                    cell.MBAuthor?.text = (author.joined(separator: ", "))
                   } else {
                    cell.MBAuthor?.text = "N/A"
                   }
            cell.MBDescr?.text = bookz.volumeInfo.description
        }
        return cell
        
    }
    
}
