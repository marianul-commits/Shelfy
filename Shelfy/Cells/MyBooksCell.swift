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
        
        showAnimation()
        
        MBTitle.clipsToBounds = true
        MBAuthor.clipsToBounds = true
        MBDescr.clipsToBounds = true

        MBTitle.linesCornerRadius = 5
        MBAuthor.linesCornerRadius = 5
        MBDescr.linesCornerRadius = 5

        MBTitle.skeletonTextNumberOfLines = 1
        MBAuthor.skeletonTextNumberOfLines = 1
    
        MBPhoto.clipsToBounds = true
        MBPhoto.layer.cornerRadius = 6
        MBView.layer.cornerRadius = 8

    }
    
    func hideAnimation() {
        MBPhoto.hideSkeleton(transition: .crossDissolve(0.25))
        MBDescr.hideSkeleton(transition: .crossDissolve(0.25))
        MBTitle.hideSkeleton(transition: .crossDissolve(0.25))
        MBAuthor.hideSkeleton(transition: .crossDissolve(0.25))
    }
    
    func showAnimation() {
        MBPhoto.showAnimatedSkeleton()
        MBDescr.showAnimatedSkeleton()
        MBTitle.showAnimatedSkeleton()
        MBAuthor.showAnimatedSkeleton()
        
        MBTitle.skeletonLineSpacing = 12
        MBAuthor.skeletonLineSpacing = 12
        
        MBTitle.skeletonPaddingInsets = .init(top: 2, left: 2, bottom: 2, right: 2)
        MBAuthor.skeletonPaddingInsets = .init(top: 2, left: 2, bottom: 2, right: 2)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
