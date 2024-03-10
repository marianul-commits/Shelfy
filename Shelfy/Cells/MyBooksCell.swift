//
//  MyBooksCell.swift
//  Shelfy
//
//  Created by Marian Nasturica on 05.06.2023.
//

import UIKit
import SkeletonView

class MyBooksCell: UITableViewCell {

    
    @IBOutlet weak var MBView: UIView!
    @IBOutlet weak var MBPhoto: UIImageView!
    @IBOutlet weak var MBTitle: UILabel!
    @IBOutlet weak var MBAuthor: UILabel!
    @IBOutlet weak var MBDescr: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        MBPhoto.showAnimatedSkeleton()
        MBDescr.showAnimatedSkeleton()
        MBTitle.showAnimatedSkeleton()
        MBAuthor.showAnimatedSkeleton()
        
        MBTitle.linesCornerRadius = 10
        MBAuthor.linesCornerRadius = 10
        MBDescr.linesCornerRadius = 10
        
        MBTitle.skeletonPaddingInsets = .init(top: 5, left: 5, bottom: 5, right: 5)
        MBAuthor.skeletonPaddingInsets = .init(top: 5, left: 5, bottom: 5, right: 5)
        MBDescr.skeletonPaddingInsets = .init(top: 5, left: 5, bottom: 5, right: 5)

        MBTitle.skeletonTextNumberOfLines = 1
        MBAuthor.skeletonTextNumberOfLines = 1
    
//        MBPhoto.layer.cornerRadius = MBPhoto.frame.size.height / 25
        MBPhoto.contentMode = .scaleAspectFit
        MBView.layer.cornerRadius = MBView.frame.size.height / 25

    }
    
    func hideAnimation() {
        MBPhoto.hideSkeleton()
        MBDescr.hideSkeleton()
        MBTitle.hideSkeleton()
        MBAuthor.hideSkeleton()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
