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
        // Initialize your UI elements here
        titleLabel = UILabel()
        imageView = UIImageView()

        // Customize your UI elements (if needed)
        titleLabel.textAlignment = .center

        // Add UI elements to the cell's content view
        contentView.addSubview(titleLabel)
        contentView.addSubview(imageView)

        // Make sure to set the following property to false
        // so we can set constraints programmatically
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 1
        titleLabel.lineBreakMode = .byTruncatingTail
    }

    private func setupConstraints() {

        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true


        imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        imageView.contentMode = .scaleAspectFit
    }
}
