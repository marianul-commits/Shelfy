//
//  SearchController.swift
//  Shelfy
//
//  Created by Marian Nasturica on 05.06.2023.
//

import UIKit

class SearchController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var searchBooks: UISearchBar!
    @IBOutlet weak var searchTable: UITableView!
    
    let testData = ["test1", "test2", "test3", "test5"]
    var filter: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filter = testData
        
        searchTable.dataSource = self
        searchTable.delegate = self
        searchTable.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        searchTable.backgroundColor = UIColor.clear
        searchTable.layer.backgroundColor = UIColor.clear.cgColor
        
    }


}


extension SearchController: UISearchBarDelegate {

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
        self.searchTable.reloadData()
    }

}


extension SearchController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! SBCell
    
    cell.clipsToBounds = true
    cell.backgroundColor = .clear
    cell.searchCellTitle?.text = testData[indexPath.row]
        
    return cell
}
    
    
}
