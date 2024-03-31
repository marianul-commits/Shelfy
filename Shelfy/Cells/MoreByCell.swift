//
//  MoreByCell.swift
//  Shelfy
//
//  Created by Marian Nasturica on 06.08.2023.
//

import UIKit

class MoreByCell: UICollectionViewCell {
    
    var titleLabel: UILabel!
    var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
    }
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupViews()
    }

     func setupViews() {
        
        titleLabel = UILabel()
        imageView = UIImageView()


        // Add UI elements to the cell's content view
        contentView.addSubview(titleLabel)
        contentView.addSubview(imageView)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 1
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.textAlignment = .center
        titleLabel.font = SetFont.setFontStyle(.regular, 14)
        imageView.contentMode = .scaleAspectFit
         
        NSLayoutConstraint.activate([
        
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
            titleLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalTo: imageView.widthAnchor),

            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -32),
            imageView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -16),
        
        ])
        
    }

}
