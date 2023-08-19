//
//  SearchController.swift
//  Shelfy
//
//  Created by Marian Nasturica on 05.06.2023.
//

import UIKit
import Vision

class SearchController: UIViewController, UITableViewDelegate {
    
    var displayBooks: [Items] = []

    let searchTable = makeTableView()
    let searchBar = makeSearchBar(withPlaceholder: "Search Books, Authors, ISBN")
    let searchBtn = makeImgButton(withImg: "camera.fill")
    let topStack = makeStackView(withOrientation: .horizontal)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchV()
        
        searchTable.dataSource = self
        searchTable.delegate = self
        searchTable.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        searchTable.backgroundColor = UIColor.clear
        searchTable.layer.backgroundColor = UIColor.clear.cgColor
        

        
    }
    
    func setupSearchV() {
        
        
        //MARK: Adding the elements to the view
        
//        topStack.addArrangedSubview(searchBar)
//        topStack.addArrangedSubview(searchBtn)
//
//        view.addSubview(topStack)
        view.addSubview(searchBar)
        view.addSubview(searchBtn)
        view.addSubview(searchTable)
        
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        searchBtn.firstBaselineAnchor.constraint(equalTo: searchBar.firstBaselineAnchor).isActive = true

        searchBtn.leadingAnchor.constraint(equalTo: searchBar.trailingAnchor, constant: 8).isActive = true
        searchBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
        searchBtn.topAnchor.constraint(equalTo: searchBar.topAnchor).isActive = true
        
//        topStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
//        topStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
//        topStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
//        topStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        searchTable.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 15).isActive = true
        searchTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        searchTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        searchTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        
        
        
    }
    
    //MARK: - Scan Button
    
    
    
}


//MARK: - SearchBar Extension
extension SearchController: UISearchBarDelegate {
    
    
    
}

//MARK: - TableView Extension
extension SearchController: UITableViewDataSource {
    
    func tableView(_ searchTable: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayBooks.count
    }
    
    func tableView(_ searchTable: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        searchTable.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ searchTable: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTable.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! SBCell
        
        cell.clipsToBounds = true
        cell.backgroundColor = .clear
        
        let bookz = displayBooks[indexPath.row]
        
        cell.searchCellTitle?.text = bookz.volumeInfo.title
        cell.searchCellDescription?.text = bookz.volumeInfo.description
        // Setting the cell author label from the API
        if let author = bookz.volumeInfo.authors {
            cell.searchCellAuthor?.text = (author.joined(separator: ", ")) ?? "N/A"
        }
        // Setting the cell image from the API
        if let imageURLString = bookz.volumeInfo.imageLinks?.thumbnail,
           let imageURL = URL(string: imageURLString) {
            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: imageURL),
                   let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        cell.scPhoto?.image = image
                    }
                }
            }
        } else {
            // If the book has no photo, set a placeholder image
            cell.scPhoto?.image = UIImage(named: "placeholder")
        }
        
        return cell
    }
    
}
