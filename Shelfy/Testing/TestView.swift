//
//  TestView.swift
//  Shelfy
//
//  Created by Marian Nasturica on 11.07.2023.
//

import UIKit
import CoreData

class TestView: UIViewController {

    // Array to store categories fetched from Core Data
    var categories = [BookCategory]()
    
    // Core Data context
    var managedObjectContext: NSManagedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup Core Data stack
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("AppDelegate not found")
        }
        managedObjectContext = appDelegate.persistentContainer.viewContext
        
        // Fetch categories from Core Data
        fetchCategories()
        
        // Create and setup UI
        setupUI()
    }
    
    func setupUI() {
        let addButton = UIButton(type: .system)
        addButton.setTitle("Add Item", for: .normal)
        addButton.addTarget(self, action: #selector(addItemButtonTapped), for: .touchUpInside)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addButton)
        
        // Constraints for the button
        addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    @objc func addItemButtonTapped() {
        if categories.isEmpty {
            // If categories array is empty, display an error message
            showAlert(message: "No categories available. Please add categories.")
        } else {
            // If categories exist, show the category selection menu
            showCategorySelectionMenu()
        }
    }
    
    func showCategorySelectionMenu() {
        let alertController = UIAlertController(title: "Select Category", message: nil, preferredStyle: .actionSheet)
        
        // Add actions for each category
        for category in categories {
            let action = UIAlertAction(title: category.name, style: .default) { _ in
                // Handle selection of category
                self.addToCategory(category)
            }
            alertController.addAction(action)
        }
        
        // Add cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }
    
    func addToCategory(_ category: BookCategory) {
        // Handle adding item to selected category
        print("Item added to category: \(category.name)")
    }
    
    func fetchCategories() {
        let fetchRequest: NSFetchRequest<BookCategory> = BookCategory.fetchRequest()
        
        do {
            categories = try managedObjectContext.fetch(fetchRequest)
        } catch {
            print("Error fetching categories: \(error.localizedDescription)")
        }
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}



