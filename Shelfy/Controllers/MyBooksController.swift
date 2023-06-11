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
    
    // Persist the top view height constraint
    var topViewHeightConstraint: NSLayoutConstraint?
    
    // Original height of the top view
    var viewHeight: CGFloat = 400
    
    // Keep track of the
    private var isAnimationInProgress = false
    
    var previousOffset: CGPoint?
    
    
    let testData = ["test1", "test2", "test3", "test5", "test14", "test12", "test13", "test15", "test11", "test22"]
    let testData2 = ["banana", "potato", "tomato", "apple", "pear", "berry", "ice", "mango", "coconut", "nutnut"]
    var filter: [String]!
    var isThisOn = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myBooksTable.delegate = self
        myBooksTable.dataSource = self
        myBooksTable.register(UINib(nibName: K.cellNibName2, bundle: nil), forCellReuseIdentifier: K.cellIdentifier2)
        myBooksTable.backgroundColor = UIColor.clear
        myBooksTable.layer.backgroundColor = UIColor.clear.cgColor
        myBooksTable.layer.cornerRadius = myBooksTable.frame.size.height / 25
//        btnView.layer.backgroundColor = CGColor(red: 0.74, green: 0.87, blue: 0.8, alpha: 1.0)
        btnView.layer.cornerRadius = btnView.frame.size.height / 2
        btnReading.layer.cornerRadius = btnReading.layer.frame.size.height / 2
        btnOnMyShelf.layer.cornerRadius = btnOnMyShelf.layer.frame.size.height / 2
        btnOnMyShelf.backgroundColor = UIColor(named: "Accent7")
        
    }
    
    @IBAction func readingBtn(_ sender: Any) {
        isThisOn = true
//        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseIn) {
//            self.btnReading.backgroundColor = UIColor(named: "Accent5")
//        }
        
        UIView.transition(with: btnReading, duration: 0.33,
                          options: .curveEaseInOut,
          animations: {
            self.btnReading.backgroundColor = UIColor(named: "Accent5")
          },
          completion: { _ in
            self.btnReading.backgroundColor = UIColor(named: "Accent5")
          }
        )
        
        btnOnMyShelf.backgroundColor = UIColor(named: "Accent7")
        btnReading.backgroundColor = UIColor(named: "Accent5")
        print("\(isThisOn)")
        myBooksTable.reloadData()
    }
    
    @IBAction func shelfyBtn(_ sender: Any) {
        isThisOn = false
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseIn) {
            self.btnOnMyShelf.backgroundColor = UIColor(named: "Accent5")
        }
        btnReading.backgroundColor = UIColor(named: "Accent7")
        btnOnMyShelf.backgroundColor = UIColor(named: "Accent5")
        print("\(isThisOn)")
        myBooksTable.reloadData()
    }
    
    
    
}



//MARK: - ScrollView Extension

extension MyBooksController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard let topViewHeightConstraint = topViewHeightConstraint
        else { return }
        
        let currentOffset = scrollView.contentOffset
        
        if let startOffset = previousOffset {
            
            // Get the distance scrolled
            let delta = abs((startOffset.y - currentOffset.y))
            
            if currentOffset.y > startOffset.y,
               currentOffset.y > .zero {
                // Scrolling down
                
                // Set the new height based on the amount scrolled
                var newHeight = topViewHeightConstraint.constant - delta
                
                // Make sure we do not go below 0
                if newHeight < .zero {
                    newHeight = .zero
                }
                
                topViewHeightConstraint.constant
                = newHeight
                
            }
            else if currentOffset.y < startOffset.y,
                    currentOffset.y <= viewHeight {
                // Scrolling up
                
                var newHeight = topViewHeightConstraint.constant + delta
                
                // Make sure we do not go above the max height
                if newHeight > viewHeight {
                    newHeight = viewHeight
                }
                
                topViewHeightConstraint.constant
                = newHeight
            }
            
            // Update the previous offset
            previousOffset = scrollView.contentOffset
            
            self.view.layoutIfNeeded()
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
        return 10
    }
    
    
    func tableView(_ myBooksTable: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = myBooksTable.dequeueReusableCell(withIdentifier: K.cellIdentifier2, for: indexPath) as! MyBooksCell
        
            cell.clipsToBounds = true
            cell.backgroundColor = .clear
            if isThisOn == true {
                cell.MBTitle?.text = testData[indexPath.row]
            } else {
                cell.MBTitle?.text = testData2[indexPath.row]
            }
            return cell
            
        }
        
    }

