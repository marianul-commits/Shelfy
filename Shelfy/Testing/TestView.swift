//
//  TestView.swift
//  Shelfy
//
//  Created by Marian Nasturica on 11.07.2023.
//

import UIKit

class TestView: UIViewController, UISearchControllerDelegate {
    
       let searchController = UISearchController(searchResultsController: nil)
    
        
    override func viewDidLoad() {
        navigationItem.searchController = searchController
        searchController.delegate = self
        searchController.searchBar.delegate = self
        setupTest()
    }
    
    func setupTest() {
        
        searchController.searchBar.showsBookmarkButton = true
        searchController.searchBar.setImage(UIImage(systemName: "camera.fill"), for: .bookmark, state: .normal)
        
        
        
        
    }
    
    
    }

extension TestView: UISearchBarDelegate {

   func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
      print("click")
   }

}

