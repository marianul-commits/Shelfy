//
//  MyBooksController.swift
//  Shelfy
//
//  Created by Marian Nasturica on 05.06.2023.
//

import UIKit
import CoreData

class MyBooksController: UIViewController {
    
    var category = [BookCategory]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var addButton = UIButton(type: .custom)
    var categoriesTable = UITableView()
    let screenSize = UIScreen.main.bounds
    var header = UILabel()
    let cellHeight:CGFloat = 160
    let padding:CGFloat = 10
    
    
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
        header.font = SetFont.setFontStyle(.medium, 24)
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
        categoriesTable.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        
        
        view.addSubview(header)
        view.addSubview(addButton)
        view.addSubview(categoriesTable)
        
        
        NSLayoutConstraint.activate([
            
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),
            
            categoriesTable.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 12),
            categoriesTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            categoriesTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
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
            
            self.category.append(newBookCategory)
            
            self.saveCategories()
            
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new Shelfy"
            
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
}

extension MyBooksController: UITableViewDataSource, UITableViewDelegate {
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        cell.textLabel?.text = category[indexPath.row].name
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Remove the item from the data array
           
            context.delete(category[indexPath.row])
            category.remove(at: indexPath.row)

            saveCategories()
        }
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
        
        let categoryVC = MyBooksCentralView()
        
        
        
        present(categoryVC, animated: true, completion: nil)
        
    }
    
}
