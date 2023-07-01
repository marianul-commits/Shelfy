//
//  MyBooksController.swift
//  Shelfy
//
//  Created by Marian Nasturica on 05.06.2023.
//

import UIKit

class MyBooksController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var myBookScrollView: UIScrollView!
    @IBOutlet weak var myBooksSearchBar: UISearchBar!
    @IBOutlet weak var myBooksTable: UITableView!
    @IBOutlet weak var btnView: UIView!
    @IBOutlet weak var btnOnMyShelf: UIButton!
    @IBOutlet weak var btnReading: UIButton!
    
    // Keep track of the
    private var isAnimationInProgress = false
    
    
    let testData = ["test1", "test2", "test3", "test5", "test14", "test12", "test13", "test15", "test11", "test22"]
    let authData = ["Ion Creanga", "Mihai Eminesc", "C. Brancoveanu", "Mircea Eliade", "JJ Abrahms", "Naruto", "Jiraya", "Sasuke", "Kakashi", "Madara"]
    let descData = ["lorem ipsum dolores", "test2", "test3", "test5", "test14", "test12", "test13", "test15", "test11", "test22"]
    let testData2 = ["banana", "potato", "tomato", "apple", "pear", "berry", "ice", "mango", "coconut", "nutnut"]
    let authData2 = ["Marvel", "DC", "SpooderMan", "Blalde", "JJ McDonalds", "Boruto", "Hinata", "Tom Ford", "YSL", "Autor"]
    let descData2 = ["lorem ipsum doloret", "cum te jucai prin cotet", "test3", "test5", "test14", "test12", "test13", "test15", "test11", "test22"]
    var filter: [String]!
    var isThisOn = true
    
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
        btnView.layer.cornerRadius = btnView.frame.size.height / 2
        btnReading.layer.cornerRadius = btnReading.layer.frame.size.height / 2
        btnOnMyShelf.layer.cornerRadius = btnOnMyShelf.layer.frame.size.height / 2
        btnOnMyShelf.backgroundColor = UIColor(named: "Accent7")
        
    }
    
    @IBAction func readingBtn(_ sender: Any) {
        isThisOn = true
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            self.btnReading.backgroundColor = UIColor(named: "Accent5")
        
    }
        btnOnMyShelf.backgroundColor = UIColor(named: "Accent7")
        btnReading.backgroundColor = UIColor(named: "Accent5")
        myBooksTable.reloadData()
    }
    
    @IBAction func shelfyBtn(_ sender: Any) {
        isThisOn = false
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            self.btnOnMyShelf.backgroundColor = UIColor(named: "Accent5")
        }
        btnReading.backgroundColor = UIColor(named: "Accent7")
        btnOnMyShelf.backgroundColor = UIColor(named: "Accent5")
        print("\(isThisOn)")
        myBooksTable.reloadData()
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
        return testData.count
    }
    
    func tableView(_ myBooksTable: UITableView, didSelectRowAt indexPath: IndexPath) {
        myBooksTable.deselectRow(at: indexPath, animated: true)
        let cell = myBooksTable.cellForRow(at: indexPath as IndexPath)
                
        if isThisOn == true {
            let selectedBook = testData[indexPath.row]
            let bookAuth = authData[indexPath.row]
            let bookDesc = descData[indexPath.row]
            let destination = BookView()
//            destination.bookAuth = bookAuth
//            destination.bookTitle = selectedBook
//            destination.bookDesc = bookDesc
            performSegue(withIdentifier: K.cellSegue, sender: cell)
            
            print("hewwo")
        } else {
            
            let selectedBook2 = testData2[indexPath.row]
            let bookAuth2 = authData2[indexPath.row]
            let bookDesc2 = descData2[indexPath.row]
            let destination2 = BookView()
//            destination2.bookAuth = bookAuth2
//            destination2.bookTitle = selectedBook2
//            destination2.bookDesc = bookDesc2
            performSegue(withIdentifier: K.cellSegue, sender: cell)
            
            print("hewwo data 2")
        }
    }
    
    func tableView(_ myBooksTable: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = myBooksTable.dequeueReusableCell(withIdentifier: K.cellIdentifier2, for: indexPath) as! MyBooksCell
        
            cell.clipsToBounds = true
            cell.backgroundColor = .clear
        cell.isUserInteractionEnabled = true
            if isThisOn == true {
                cell.MBTitle?.text = testData[indexPath.row]
                cell.MBAuthor?.text = authData[indexPath.row]
                cell.MBDescr?.text = descData[indexPath.row]
            } else {
                cell.MBTitle?.text = testData2[indexPath.row]
                cell.MBAuthor?.text = authData2[indexPath.row]
                cell.MBDescr?.text = descData2[indexPath.row]
            }
            return cell
            
        }
        
    }

