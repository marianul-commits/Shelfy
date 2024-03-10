//
//  TestView.swift
//  Shelfy
//
//  Created by Marian Nasturica on 11.07.2023.
//

import UIKit
import CoreData

class TestView: UIViewController {
    
    var category = [BookCategory]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var tableView = UITableView()
    var addButton = UIButton()
    let cellHeight: CGFloat = 160
    let padding: CGFloat = 10
    let cellInset: CGFloat = 12
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
        // Create UITableView
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        
        // Create UIButton
        addButton = UIButton(type: .custom)
        addButton.setImage(UIImage(systemName: "plus"), for: .normal)
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.filled()
            config.cornerStyle = .capsule
            config.contentInsets = NSDirectionalEdgeInsets(top: 7, leading: 5, bottom: 7, trailing: 5)
            config.baseBackgroundColor = UIColor(resource: .brandPurple)
            addButton.configuration = config
            addButton.addTarget(self, action: #selector(addButtonTapped(_:)), for: .touchUpInside)
        } else {
            addButton.layer.cornerRadius = 20
            addButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
            addButton.backgroundColor = UIColor(resource: .brandPurple)
            addButton.tintColor = .black
            addButton.addTarget(self, action: #selector(addButtonTapped(_:)), for: .touchUpInside)
        }
        view.addSubview(addButton)
        
        // Set UIButton constraints
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        
        // Set UITableView constraints
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -20).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    func saveCategories() {
        
        do {
            try context.save()
        } catch {
            print("error saving \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    func loadCategories() {
        
        let request: NSFetchRequest<BookCategory> = BookCategory.fetchRequest()
        do {
            category = try context.fetch(request)
        } catch {
            print("error loading: \(error)")
        }
        
    }
    
    
    @objc func addButtonTapped(_ sender: UIButton) {
        
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


extension TestView: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        cell.textLabel?.text = category[indexPath.row].name
        //        let horizontalPadding: CGFloat = 20
        //        let verticalPadding: CGFloat = 8
        //        cell.contentView.layoutMargins = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight + padding
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Remove the item from the data array
           
            context.delete(category[indexPath.row])
            category.remove(at: indexPath.row)

            saveCategories()
        }
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
