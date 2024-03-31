//
//  CustomFlowLayout.swift
//  Shelfy
//
//  Created by Marian Nasturica on 06.08.2023.
//

import UIKit

class CustomFlowLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        scrollDirection = .horizontal
        minimumLineSpacing = 8
        minimumInteritemSpacing = 8
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        scrollDirection = .horizontal
        minimumLineSpacing = 8
        minimumInteritemSpacing = 8
    }

    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }

        // Calculate the total available width for the cells
        let totalSpacingWidth = minimumInteritemSpacing * CGFloat(2 - 1) // 2 cells with 1 spacing in between
        let collectionViewWidth = collectionView.bounds.width - sectionInset.left - sectionInset.right - totalSpacingWidth

        // Calculate the width for each cell
        let customCellWidth: CGFloat = collectionViewWidth / 2

        // Set the item size to your custom cell size
        let customCellHeight: CGFloat = 220
        itemSize = CGSize(width: customCellWidth, height: customCellHeight)
    }
}

class CategoriesHorizontalFlow: UICollectionViewFlowLayout {
    
    // Array containing text data for cells
    var data: [String] = []
    
    override init() {
        super.init()
        scrollDirection = .horizontal
        minimumLineSpacing = 5
        minimumInteritemSpacing = 5
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        scrollDirection = .horizontal
        minimumLineSpacing = 5
        minimumInteritemSpacing = 5
    }

    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }
        
        // Calculate the total available width for the cells
        let totalSpacingWidth = minimumInteritemSpacing * CGFloat(data.count - 1)
        let collectionViewWidth = collectionView.bounds.width - totalSpacingWidth

        // Calculate the width for each cell based on the text content
        var maxWidth: CGFloat = 0
        for text in data {
            let textWidth = (text as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]).width
            if textWidth > maxWidth {
                maxWidth = textWidth
            }
        }
        let cellWidth = maxWidth + 40 // 5 points of insets on both left and right sides

        // Set the item size to the calculated cell size
        itemSize = CGSize(width: cellWidth, height: 40)
    }
}
