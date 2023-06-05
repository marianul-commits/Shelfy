//
//  SearchCell.swift
//  Shelfy
//
//  Created by Marian Nasturica on 05.06.2023.
//

import UIKit

class SBCell: UITableViewCell {

    @IBOutlet weak var scPhoto: UIImageView!
    @IBOutlet weak var searchCellTitle: UILabel!
    @IBOutlet weak var searchCellAuthor: UILabel!
    @IBOutlet weak var searchCellDescription: UILabel!
    @IBOutlet weak var searchCellView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        scPhoto.layer.cornerRadius = scPhoto.frame.size.height / 25
        searchCellView.layer.cornerRadius = searchCellView.frame.size.height / 25
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
