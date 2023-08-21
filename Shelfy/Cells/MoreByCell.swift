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
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        
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
    }

    private func setupConstraints() {

        let imageWidthPercentage: CGFloat = 0.32
        let imageHeightPercentage: CGFloat = 0.22
        
        let imageWidthConstant = UIScreen.main.bounds.width * imageWidthPercentage
        let imageHeightConstant = UIScreen.main.bounds.height * imageHeightPercentage
        
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true


        imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: imageHeightConstant).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: imageWidthConstant).isActive = true
        imageView.contentMode = .scaleAspectFit
    }
}
