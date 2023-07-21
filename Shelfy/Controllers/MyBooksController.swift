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
    let testData = [String]()
    let authData = ["Ion Creanga", "Mihai Eminesc", "C. Brancoveanu", "Mircea Eliade", "JJ Abrahms", "Naruto", "Jiraya", "Sasuke", "Kakashi", "Madara"]
    let descData = ["lorem ipsum dolores", "test2", "test3", "test5", "test14", "test12", "test13", "test15", "test11", "test22"]
    let testData2 = [String]()
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
        let font = UIFont(name: "MicroPremium-Regular", size: 16)
        segCtrl.setTitleTextAttributes([NSAttributedString.Key.font: font!], for: .selected)
        let font2 = UIFont(name: "MicroPremium-Light", size: 16)
        segCtrl.setTitleTextAttributes([NSAttributedString.Key.font: font2!], for: .normal)
        segCtrl.setTitleTextAttributes([.foregroundColor: UIColor(named: "Accent5")!], for: .normal)
        segCtrl.setTitleTextAttributes([.foregroundColor: UIColor(named: "Accent6")!], for: .selected)
        searcBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: myBooksTable.frame.width, height: 50))
        searcBar.delegate = self
        searcBar.placeholder = "Find books"
        searcBar.backgroundColor = UIColor.clear
        searcBar.searchBarStyle = .minimal
        searcBar.tintColor = UIColor(named: "Color1")!
        searcBar.isHidden = testData.count <= 15
        myBooksTable.tableHeaderView = searcBar
  
        
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
        if testData.count == 0 {
            self.myBooksTable.setEmptyMessage(EmptyTable.message.randomElement()!)
        }else{
            self.myBooksTable.restore()
        }
        return testData.count
    }
    
    // Disable table view scrolling when the data source is empty
        func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
            if testData.isEmpty {
                scrollView.isScrollEnabled = false
            } else {
                scrollView.isScrollEnabled = true
            }
        }
    
    func tableView(_ myBooksTable: UITableView, didSelectRowAt indexPath: IndexPath) {
        myBooksTable.deselectRow(at: indexPath, animated: true)

        let cell = myBooksTable.cellForRow(at: indexPath as IndexPath)
        
        if isThisOn == true {
            let selectedBook = testData[indexPath.row]
            let bookAuth = authData[indexPath.row]
            let bookDesc = descData[indexPath.row]
            
            func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                
                let destinationVC = segue.destination as! BookView
                
                if let indexPath = myBooksTable.indexPathForSelectedRow{
                    destinationVC.bookAuth.text = bookAuth
                    destinationVC.bookTitle.text = selectedBook
                    destinationVC.descrLbl.text = bookDesc
                }
                
            }
            
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

extension UITableView {

    func setEmptyMessage(_ message: String) {
        let padding = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 30)
        let container = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
        let messageLabel = UILabel(frame: container)
        messageLabel.frame = container.inset(by: padding)
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = SetFont.setFontStyle(.medium, 16)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .none
    }
}
