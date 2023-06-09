//
//  MyBooksCell.swift
//  Shelfy
//
//  Created by Marian Nasturica on 05.06.2023.
//

import UIKit

class MyBooksCell: UITableViewCell {

    
    @IBOutlet weak var MBView: UIView!
    @IBOutlet weak var MBPhoto: UIImageView!
    @IBOutlet weak var MBTitle: UILabel!
    @IBOutlet weak var MBAuthor: UILabel!
    @IBOutlet weak var MBDescr: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        MBPhoto.layer.cornerRadius = MBPhoto.frame.size.height / 25
        MBView.layer.cornerRadius = MBView.frame.size.height / 25
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
