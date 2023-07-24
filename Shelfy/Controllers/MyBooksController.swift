//
//  MyBooksController.swift
//  Shelfy
//
//  Created by Marian Nasturica on 05.06.2023.
//

import UIKit
import Kingfisher

class MyBooksController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var myBooksTable: UITableView!
    @IBOutlet weak var segCtrl: UISegmentedControl!
    
    var searcBar: UISearchBar!
    let testData = EmptyTable.bookTitle
    let authData = EmptyTable.bookAuthors
    let descData = EmptyTable.bookDescriptions
    let testData2 = EmptyTable.bookTitles2
    let authData2 = EmptyTable.bookAuthors2
    let descData2 = EmptyTable.bookDescriptions2
    var filter: [String]!
    var isThisOn = true
    var books: [Items] = []
    
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
        segCtrl.setTitleTextAttributes([NSAttributedString.Key.font: SetFont.setFontStyle(.light, 16)], for: .normal)
        segCtrl.setTitleTextAttributes([.foregroundColor: UIColor(named: "Accent5")!], for: .normal)
        segCtrl.setTitleTextAttributes([.foregroundColor: UIColor(named: "Accent6")!], for: .selected)
        // Search Bar as Table View header customization
        searcBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: myBooksTable.frame.width, height: 50))
        searcBar.delegate = self
        searcBar.placeholder = "Find books"
        searcBar.backgroundColor = UIColor.clear
        searcBar.searchBarStyle = .minimal
        searcBar.tintColor = UIColor(named: "Color1")!
        searcBar.isHidden = testData.count <= 15
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filter = []
        if searchText == ""
        {
            filter = testData
        }
        
        for word in testData{
            if word.uppercased().contains(searchText.uppercased()){
                filter.append(word)
            }
        }
        self.myBooksTable.reloadData()
    }
    
}


//MARK: - TableView Extension

extension MyBooksController: UITableViewDataSource {
    
    func tableView(_ myBooksTable: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isThisOn == true{
            if books.count == 0 {
                self.myBooksTable.setEmptyMessage(EmptyTable.message.randomElement()!)
            }else{
                self.myBooksTable.restore()
            }
            return books.count
        } else {
            if testData2.count == 0 {
                self.myBooksTable.setEmptyMessage(EmptyTable.message.randomElement()!)
            }else{
                self.myBooksTable.restore()
            }
            return testData2.count
        }
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
        else {
            if testData2.isEmpty {
                scrollView.isScrollEnabled = false
            } else {
                scrollView.isScrollEnabled = true
            }
        }
    }
    
    func tableView(_ myBooksTable: UITableView, didSelectRowAt indexPath: IndexPath) {
        myBooksTable.deselectRow(at: indexPath, animated: true)
        
        let cell = myBooksTable.cellForRow(at: indexPath as IndexPath)
        
        if isThisOn == true {
  
            print("Data Set 1")
        } else {
            
//            let selectedBook2 = testData2[indexPath.row]
//            let bookAuth2 = authData2[indexPath.row]
//            let bookDesc2 = descData2[indexPath.row]
//            let destination2 = BookView()
            //            destination2.bookAuth = bookAuth2
            //            destination2.bookTitle = selectedBook2
            //            destination2.bookDesc = bookDesc2
//            performSegue(withIdentifier: K.cellSegue, sender: cell)
            
            print("Data Set 2")
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
            if let author = bookz.volumeInfo.authors {
                    cell.MBAuthor?.text = (author.joined(separator: ", "))
                   } else {
                    cell.MBAuthor?.text = "N/A"
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
          
            // Data Set 2 enabled
        } else {
            cell.MBTitle?.text = testData2[indexPath.row]
            cell.MBAuthor?.text = authData2[indexPath.row]
            cell.MBDescr?.text = descData2[indexPath.row]
        }
        return cell
        
    }
    
}
