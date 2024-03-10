//
//  MyBooksCentralView.swift
//  Shelfy
//
//  Created by Marian Nasturica on 02.07.2023.
//

import UIKit
import CoreData

class MyBooksCentralView: UIViewController {
    
    var bookItems = [BookItem]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedCategory: BookCategory? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    func loadItems() {
        
        let request: NSFetchRequest<BookItem> = BookItem.fetchRequest()
        do {
            bookItems = try context.fetch(request)
        } catch {
            print("error loading: \(error)")
        }
        
    }
    
}
