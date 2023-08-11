//
//  DescrView.swift
//  Shelfy
//
//  Created by Marian Nasturica on 07.08.2023.
//

//import UIKit
//
//class DescrView: UIView {
//
//    var title: String
//    var descrLbl: String
//
//    init(title: String, descrLbl: String) {
//        self.title = title
//        self.descrLbl = descrLbl
//
//        super.init(frame: .zero)
//
//        setupViews()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func setupViews() {
//        let titleLabel = makeLabel(withText: title)
////        let scrollV = makeScrollView()
//        let descr = makeLabel(withText: descrLbl)
//
//        addSubview(titleLabel)
//        addSubview(scrollV)
//        scrollV.addSubview(descr)
//
//        // Everything flush to edges...
//        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
//        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
//        scrollV.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
//        scrollV.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        descr.topAnchor.constraint(equalTo: scrollV.topAnchor, constant: 5).isActive = true
//        descr.leadingAnchor.constraint(equalTo: scrollV.leadingAnchor, constant: 5).isActive = true
//
//
//    }
//
//}
