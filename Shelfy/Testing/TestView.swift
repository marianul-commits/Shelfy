//
//  TestView.swift
//  Shelfy
//
//  Created by Marian Nasturica on 11.07.2023.
//

import UIKit
import CoreData
import NotificationBannerSwift
import SkeletonView
import Cosmos

import UIKit

class TestView: UIViewController {
    
//    let viewModel = TestVM()
    
    var books: [OLBook]?
    var bookz: [OLBook]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for _ in 1...5 {
//            
//            fetchBookz { (books) in
//            }
            
            fetchBooksAsync { (books) in
            }
            
        }
        
    }
}


//class TestView: UIViewController {
//    
//
//    let spacer = UIView()
//    
//    // Define UICollectionView
//    lazy var collectionView = makeCollectionView()
//    
//    // Data source
//    let data = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6", "Item 7", "Item 8", "Item 9", "Item 10"]
//
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        spacer.translatesAutoresizingMaskIntoConstraints = false
////        spacer.backgroundColor = .systemPink
//        
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
//        
//        
//        // Add UICollectionView to the view
//        view.addSubview(collectionView)
//        view.addSubview(spacer)
//        
//        
//        // Set constraints for the collection view
//        NSLayoutConstraint.activate([
//            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
//            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
//            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
//            collectionView.bottomAnchor.constraint(equalTo: spacer.topAnchor),
////            collectionView.heightAnchor.constraint(equalToConstant: 60),
//            
//            spacer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            spacer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            spacer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            spacer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
//        ])
//        
//    }
//    
//}
//
//extension TestView: UICollectionViewDelegate {
//    
//}
//
//
//extension TestView: UICollectionViewDataSource{
//    // MARK: - UICollectionViewDataSource Methods
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return data.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
//        cell.backgroundColor = .clear
//        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
//        label.textAlignment = .center
//        label.textColor = UIColor.white
//        label.backgroundColor = UIColor.asbestos
//        label.layer.cornerRadius = 6
//        label.text = data[indexPath.item]
//        cell.contentView.addSubview(label)
//        return cell
//    }
//    
//    // MARK: - UICollectionViewDelegate
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("Selected item: \(data[indexPath.item])")
//    }
//}
