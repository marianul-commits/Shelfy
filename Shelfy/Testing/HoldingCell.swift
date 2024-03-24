//
//  HoldingCell.swift
//  Shelfy
//
//  Created by Marian Nasturica on 27.02.2024.
//

import UIKit

class HoldingCell: UIViewController {

/*
 
 
 func addButton() {
 
 let context = (UIApplication.shared.delegate as! AppDelegate).presistentContainer.viewContext
 
 let newBook = BookItem(context: context)
 
 newBook.title = bTitle
 newBook.author = bAuthor
 newBook.status = ...ceva gen bStatus (read/not read)
 newBook.pages = bPages
 
 }
 
 //MARK: - Move books between categories
 
 func moveItem(from sourceCategory: BookCategory, atIndex sourceIndex: Int, to destinationCategory: BookCategory) {
     // Fetch the source category
     let fetchRequest: NSFetchRequest<BookItem> = BookItem.fetchRequest()
     fetchRequest.predicate = NSPredicate(format: "parentCategory == %@", sourceCategory)
     
     do {
         let items = try managedObjectContext.fetch(fetchRequest)
         if let itemToMove = items[safe: sourceIndex] { // Make sure to handle index out of bounds
             // Update the item's relationship to point to the new category
             itemToMove.parentCategory = destinationCategory
             
             // Save the managed object context to persist the changes
             try managedObjectContext.save()
         } else {
             print("Item at index \(sourceIndex) not found in category \(sourceCategory.name ?? "Unknown")")
         }
     } catch {
         print("Error fetching items: \(error)")
     }
 }
}
 
 
 
 //MARK: - Change progress lbl to be % or x/y
 var isPercentageDisplay = false // Flag to track whether percentage or pages read is displayed

 var toggleButton = UIButton()
 
 toggleButton.setTitle("", for: .normal)
 toggleButton.setImage(UIImage(systemName: "percent"), for: .normal)
 if #available(iOS 15.0, *) {
     var config = UIButton.Configuration.filled()
     config.cornerStyle = .capsule
     config.contentInsets = NSDirectionalEdgeInsets(top: 7, leading: 5, bottom: 7, trailing: 5)
     config.baseBackgroundColor = UIColor(resource: .brandYellow)
     toggleButton.configuration = config
     toggleButton.addTarget(self, action: #selector(toggleDisplay(_:)), for: .touchUpInside)
 } else {
     toggleButton.layer.cornerRadius = 20
     toggleButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
     toggleButton.backgroundColor = UIColor(resource: .brandYellow)
     toggleButton.tintColor = .black
     toggleButton.addTarget(self, action: #selector(toggleDisplay(_:)), for: .touchUpInside)
 }
 
 func updateProgressLabel() {
     if let pagesRead = pagesRead {
         if isPercentageDisplay {
             let percentage = Int(Double(pagesRead) / Double(totalPages) * 100)
             progressLbl.text = "\(percentage)%"
         } else {
             progressLbl.text = "\(pagesRead) / \(totalPages) pages"
         }
     } else {
         // Handle the case where pagesRead is nil
         progressLbl.text = "N/A"
     }
 }
 
 // Button action to toggle between pages read and percentage
 @objc func toggleDisplay(_ sender: UIButton) {
     isPercentageDisplay.toggle()
     updateProgressLabel() // Update the progress label text
 }
 
 
 import CoreData

 // Assuming BookItem is your Core Data entity class
 func getAllBookPages() -> [String] {
     var bookPages: [String] = []

     // Create a fetch request to fetch all BookItem objects
     let fetchRequest: NSFetchRequest<BookItem> = BookItem.fetchRequest()

     do {
         // Execute the fetch request
         let bookItems = try context.fetch(fetchRequest)

         // Iterate over the fetched BookItem objects
         for bookItem in bookItems {
             // Extract the bookPages attribute from each BookItem and add it to the array
             if let bookPage = bookItem.bookPages {
                 bookPages.append(bookPage)
             }
         }
     } catch {
         print("Error fetching book items: \(error)")
     }

     return bookPages
 }

 
 */
    
    
}


class CustomTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureCell()
    }
    
    private func configureCell() {
        // Center align the text
        textLabel?.textAlignment = .center
        textLabel?.font = SetFont.setFontStyle(.regular, 16)
        
        // Set background color to pink
        backgroundColor = UIColor(resource: .brandPink)
        
        // Set corner radius
        layer.cornerRadius = 12
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Adjust the frame to match the desired height
        var frame = contentView.frame
        frame.size.height = 80
        contentView.frame = frame
    }
}
