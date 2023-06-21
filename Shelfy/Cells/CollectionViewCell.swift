//
//  CollectionViewCell.swift
//  Shelfy
//
//  Created by Marian Nasturica on 16.06.2023.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var collectionImg: UIImageView!
    @IBOutlet weak var collectionTitle: UILabel!
    @IBOutlet weak var titleView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleView.layer.cornerRadius = titleView.frame.size.height / 25
        
        // Initialization code
    }

}
