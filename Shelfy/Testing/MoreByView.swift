//
//  MoreByView.swift
//  Shelfy
//
//  Created by Marian Nasturica on 07.08.2023.
//

import UIKit

class MoreByView: UIView {

    var title: String

    init(title: String) {
        self.title = title

        super.init(frame: .zero)

        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        let titleLabel = makeLabel(withText: title)
        let collectionV = makeCollectionView()

        addSubview(titleLabel)
        addSubview(collectionV)

        // Everything flush to edges...
        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        collectionV.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        collectionV.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
    }

}
