//
//  BookViewV2.swift
//  Shelfy
//
//  Created by Marian Nasturica on 06.08.2023.
//

import UIKit

//class BookViewV2: UIViewController {
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        setupBookView()
//        
//    }
//
//    func setupBookView() {
//        
//        let bookImg = makeImgView(withImage: "placeholder")
//        let bookTitle = makeLabel(withText: "Title")
//        let bookAuthor = makeLabel(withText: "Author")
//        let bookDetailStack = makeStackView(withAxis: .vertical, withSpacing: 4, withAlignment: .center, withDistribution: .fill)
//        let buyBtn = makeButton(withTitle: "Buy")
//        let readBtn = makeButton(withTitle: "Read")
//        let shelfyBtn = makeButton(withTitle: "Add to Shelfy")
//        let btnStack = makeStackView(withAxis: .horizontal, withSpacing: 4, withAlignment: .center, withDistribution: .fillProportionally)
//        let descrView = makeView("Accent9")
//        let dVLbl = makeLabel(withText: "Description")
//        let dVScroll = makeScrollView()
//        let dVSLbl = makeLabel(withText: "Description Long")
//        let moreByView = makeView("Accent9")
//        let mVLbl = makeLabel(withText: "More By Author")
//        let mVCollView = makeCollectionView()
//        let bookSV = makeScrollView()
//        
//        view.addSubview(bookImg)
//        view.addSubview(bookDetailStack)
//        bookDetailStack.addArrangedSubview(bookTitle)
//        bookDetailStack.addArrangedSubview(bookAuthor)
//        btnStack.addArrangedSubview(buyBtn)
//        btnStack.addArrangedSubview(readBtn)
//        btnStack.addArrangedSubview(shelfyBtn)
//        view.addSubview(descrView)
//        descrView.addSubview(dVLbl)
//        descrView.addSubview(dVScroll)
//        dVScroll.addSubview(dVSLbl)
//        view.addSubview(moreByView)
//        moreByView.addSubview(mVLbl)
//        moreByView.addSubview(mVCollView)
//        
//        NSLayoutConstraint.activate([
//            
//            //Book Image Constraints
//            bookImg.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
//            bookImg.heightAnchor.constraint(equalToConstant: 220),
//            bookImg.widthAnchor.constraint(equalToConstant: 150),
//            bookImg.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            //Book Name Constraints
//            bookDetailStack.centerXAnchor.constraint(equalTo: bookImg.centerXAnchor),
//            bookDetailStack.topAnchor.constraint(equalTo: bookImg.bottomAnchor, constant: 8),
//            //Button Constraints
//            btnStack.topAnchor.constraint(equalTo: bookDetailStack.bottomAnchor, constant: 15),
//            btnStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
//            btnStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
//            //Book Scroll View Constraints
//            bookSV.topAnchor.constraint(equalTo: btnStack.bottomAnchor, constant: 15),
//            bookSV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
//            bookSV.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
//            bookSV.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            //Description View Constraints
//            descrView.topAnchor.constraint(equalTo: bookSV.topAnchor, constant: 15),
//            descrView.leadingAnchor.constraint(equalTo: bookSV.leadingAnchor, constant: 5),
//            descrView.trailingAnchor.constraint(equalTo: bookSV.trailingAnchor, constant: -5),
//            descrView.heightAnchor.constraint(equalToConstant: 240),
//            dVLbl.leadingAnchor.constraint(equalTo: descrView.leadingAnchor, constant: 10),
//            dVLbl.topAnchor.constraint(equalTo: descrView.topAnchor, constant: 8),
//            dVScroll.topAnchor.constraint(equalTo: dVLbl.bottomAnchor, constant: 8),
//            dVScroll.bottomAnchor.constraint(equalTo: descrView.bottomAnchor, constant: -20),
//            dVScroll.centerXAnchor.constraint(equalTo: descrView.centerXAnchor),
//            dVScroll.leadingAnchor.constraint(equalTo: descrView.leadingAnchor),
//            dVScroll.trailingAnchor.constraint(equalTo: descrView.trailingAnchor),
//            dVSLbl.leadingAnchor.constraint(equalTo: descrView.leadingAnchor, constant: 20),
//            dVSLbl.trailingAnchor.constraint(equalTo: descrView.trailingAnchor, constant: -20),
//            dVSLbl.topAnchor.constraint(equalTo: dVScroll.topAnchor, constant: 5),
//            dVSLbl.bottomAnchor.constraint(equalTo: dVScroll.bottomAnchor),
//            //More By Constraints
//            moreByView.topAnchor.constraint(equalTo: descrView.bottomAnchor, constant: 15),
//            moreByView.leadingAnchor.constraint(equalTo: bookSV.leadingAnchor, constant: 5),
//            moreByView.trailingAnchor.constraint(equalTo: bookSV.trailingAnchor, constant: -5),
//            moreByView.bottomAnchor.constraint(equalTo: bookSV.bottomAnchor, constant: -5),
//            mVLbl.topAnchor.constraint(equalTo: moreByView.topAnchor, constant: 8),
//            mVLbl.leadingAnchor.constraint(equalTo: moreByView.leadingAnchor, constant: 10),
//            mVCollView.topAnchor.constraint(equalTo: mVLbl.bottomAnchor, constant: 10),
//            mVCollView.leadingAnchor.constraint(equalTo: moreByView.leadingAnchor),
//            mVCollView.trailingAnchor.constraint(equalTo: moreByView.trailingAnchor),
//            mVCollView.bottomAnchor.constraint(equalTo: moreByView.bottomAnchor, constant: -10),
//            moreByView.heightAnchor.constraint(equalToConstant: 240),
//            
//            ])
//        
//        
//    }
//    
//}
