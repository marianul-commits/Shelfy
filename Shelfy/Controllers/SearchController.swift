//
//  SearchController.swift
//  Shelfy
//
//  Created by Marian Nasturica on 05.06.2023.
//

import UIKit
import Vision

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

    //MARK: - Scan Button
    
    @IBAction func scanButton(_ sender: Any) {
        
        let request = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                fatalError("Received invalid observations")
            }

            for observation in observations {
                guard let bestCandidate = observation.topCandidates(1).first else {
                    print("No candidate")
                    continue
                }

                print("Found this candidate: \(bestCandidate.string)")
            }
        }
        
        let requests = [request]

        DispatchQueue.global(qos: .userInitiated).async {
            guard let img = UIImage(named: "testImage")?.cgImage else {
                 fatalError("Missing image to scan")
            }

            let handler = VNImageRequestHandler(cgImage: img, options: [:])
            try? handler.perform(requests)
        }
        
        request.recognitionLevel = .fast
        
    }
    
    
    
}


//MARK: - SearchBar Extension
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

//MARK: - TableView Extension
extension SearchController: UITableViewDataSource {
    
    func tableView(_ searchTable: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testData.count
    }
    
    func tableView(_ searchTable: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        searchTable.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    func tableView(_ searchTable: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = searchTable.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! SBCell
    
    cell.clipsToBounds = true
    cell.backgroundColor = .clear
    cell.searchCellTitle.text = testData[indexPath.row]
        
    return cell
}
    
    
}
