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
