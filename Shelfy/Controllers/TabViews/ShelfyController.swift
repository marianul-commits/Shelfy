//
//  MyBooksController.swift
//  Shelfy
//
//  Created by Marian Nasturica on 05.06.2023.
//

import UIKit
import CoreData

class ShelfyController: UIViewController {
    
    var category = [BookCategory]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var addButton = UIButton(type: .custom)
    var categoriesTable = UITableView()
    let screenSize = UIScreen.main.bounds
    var header = UILabel()
    let cellHeight:CGFloat = 160
    let padding:CGFloat = 10
    let backBtn = UIButton(type: .custom)
    
    
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
        
        loadCategories()
        
        setupView()
        
    }
    
    func setupView() {
        
        header.translatesAutoresizingMaskIntoConstraints = false
        header.font = SetFont.setFontStyle(.medium, 22)
        header.text = "Your Shelfies"
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.setImage(UIImage(systemName: "plus"), for: .normal)
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.filled()
            config.cornerStyle = .capsule
            config.contentInsets = NSDirectionalEdgeInsets(top: 7, leading: 5, bottom: 7, trailing: 5)
            config.baseBackgroundColor = UIColor(resource: .brandPurple)
            addButton.configuration = config
            addButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        } else {
            addButton.layer.cornerRadius = 20
            addButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
            addButton.backgroundColor = UIColor(resource: .brandPurple)
            addButton.tintColor = .black
            addButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        }
        
        categoriesTable.dataSource = self
        categoriesTable.delegate = self
        categoriesTable.translatesAutoresizingMaskIntoConstraints = false
        categoriesTable.backgroundColor = .clear
        categoriesTable.register(CategoryCell.self, forCellReuseIdentifier: "cell")
        
        
        view.addSubview(header)
        view.addSubview(addButton)
        view.addSubview(categoriesTable)
        view.addSubview(backBtn)
        
        
        NSLayoutConstraint.activate([

            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            header.leadingAnchor.constraint(equalTo: categoriesTable.leadingAnchor),
            
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),
            
            categoriesTable.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 12),
            categoriesTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoriesTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoriesTable.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -12),
            
        ])
        
    }
    
    func saveCategories() {
        
        do {
            try context.save()
        } catch {
            print("error saving \(error)")
        }
        
        categoriesTable.reloadData()
        
    }
    
    func loadCategories() {
        
        let request: NSFetchRequest<BookCategory> = BookCategory.fetchRequest()
        do {
            category = try context.fetch(request)
        } catch {
            print("error loading: \(error)")
        }
        
    }
    
    @objc func buttonPressed() {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add a new Shelfy", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newBookCategory = BookCategory(context: self.context)
            newBookCategory.name = textField.text!
            
            if textField.text != " "{
                self.category.append(newBookCategory)
                self.saveCategories()
            } else {
                let error = UIAlertController(title: "Error", message: "Cannot add empty category", preferredStyle: .alert)
                let errorAction = UIAlertAction(title: "OK", style: .default)
                error.addAction(errorAction)
                self.present(error, animated: true, completion: nil)
            }
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(action)
        alert.addAction(cancelAction)
        
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Shelfy's name"
            
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
}

extension ShelfyController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if category.count == 0 {
            self.categoriesTable.setEmptyMessage(EmptyTable.shelfMsg.randomElement()!)
            return 0
        } else {
            self.categoriesTable.restore()
            return category.count
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if category.isEmpty {
            scrollView.isScrollEnabled = false
        } else {
            scrollView.isScrollEnabled = true
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CategoryCell
        cell.textLabel?.text = category[indexPath.row].name
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            // Handle the deletion
            self.deleteCategory(at: indexPath)
            completionHandler(true)
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        
        deleteAction.backgroundColor = .red
        
        // Return the actions configuration
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }

    func deleteCategory(at indexPath: IndexPath) {
        // Perform deletion logic here
        context.delete(category[indexPath.row])
        category.remove(at: indexPath.row)
        self.categoriesTable.deleteRows(at: [indexPath], with: .fade)
        saveCategories()
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight + padding
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Apply inset constraints
        let verticalPadding: CGFloat = 8
        
        let maskLayer = CALayer()
        maskLayer.cornerRadius = 10 // Optional: if you want round edges
        maskLayer.backgroundColor = UIColor.white.cgColor // Set the desired background color
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 4, dy: verticalPadding/2)
        cell.layer.mask = maskLayer
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategory = category[indexPath.row]
        
        let categoryVC = ShelfyItemsView()
        categoryVC.selectedCategory = selectedCategory
        categoryVC.modalPresentationStyle = .overFullScreen
        categoryVC.view.backgroundColor = UIColor(resource: .background)
        tableView.deselectRow(at: indexPath, animated: true)
        present(categoryVC, animated: true, completion: nil)
    }
    
}
