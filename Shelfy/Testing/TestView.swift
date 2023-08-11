//
//  TestView.swift
//  Shelfy
//
//  Created by Marian Nasturica on 11.07.2023.
//

import UIKit

class TestView: UIViewController, UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func didSelectItem(at indexPath: IndexPath) {
        let selectedItemNumber = indexPath.item + 1
        let alertController = UIAlertController(title: "Item Selected", message: "You selected item #\(selectedItemNumber)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    let bookImg = makeImgView(withImage: "placeholder")
    let bookImg2 = makeImgView(withImage: "placeholder")
    let bookTitle = makeLabel(withText: "Title")
    let bookAuthor = makeLabel(withText: "Author")
    let buyBtn = makeButton(withTitle: "Share")
    let readBtn = makeButton(withTitle: "Did Read")
    let shelfyBtn = makeButton(withTitle: "Add to Shelfy")
    let btnStack = makeStackView(withOrientation: .horizontal)
    let spacer = makeSpacerView()
    let spacer2 = makeSpacerView()
    let spacer3 = makeSpacerView()
    let spacer4 = makeSpacerView()
    let descrView = makeView(color: UIColor(named: "Accent9")!)
    let descrHeader = makeLabel(withText: "Description")
    let descrContent = makeLabel(withText: "Description Long Long very long")
    let moreView = makeCollectionView()
    let stackView = makeStackView(withOrientation: .vertical)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupBoo2kView()
        view.backgroundColor = UIColor(named: "Background")
        moreView.dataSource = self
        moreView.delegate = self
        moreView.register(MoreByCell.self, forCellWithReuseIdentifier: "testIdentifier")
    }
    
    func setupBoo2kView() {
        
        let screenBound = UIScreen.main.bounds
        let middleX = screenBound.width / 2
        let middleY = screenBound.height / 2
        
        let bookSV = UIScrollView(frame: CGRect(x: middleX, y: middleY, width: screenBound.width, height: screenBound.height / 2))
        bookSV.translatesAutoresizingMaskIntoConstraints = false
        bookSV.contentSize = CGSize(width: screenBound.width * 2, height: screenBound.height / 2)
        bookSV.isPagingEnabled = true
        bookSV.alwaysBounceVertical = false
        scrollViewDidScroll(bookSV)
        
        let descrScroll = UIScrollView(frame: CGRect(x: 20, y: 10, width: descrView.bounds.width, height: descrView.bounds.height))
        descrScroll.translatesAutoresizingMaskIntoConstraints = false
        descrScroll.contentSize = CGSize(width: descrView.bounds.width, height: descrView.bounds.height)

        let testView = UIView(frame: CGRect(x: 0, y: 0, width: screenBound.width, height: 400))
        testView.backgroundColor = .orange
        
        let mainView1 = TopView()
        let mainView2 = BottomView()
        
        
        
        let testView2 = UIView(frame: CGRect(x: screenBound.width, y: 0, width: screenBound.width, height: 400))
        testView2.backgroundColor = .cyan
        
        
        bookTitle.font = SetFont.setFontStyle(.regular, 16)
        bookTitle.textColor = .label
        bookAuthor.font = SetFont.setFontStyle(.light, 14)
        bookAuthor.textColor = .label
        
        mainView1.addSubview(bookImg2)
        mainView1.addSubview(bookTitle)
        mainView1.addSubview(bookAuthor)
        mainView1.addSubview(btnStack)
        stackView.addArrangedSubview(mainView1)
        stackView.addArrangedSubview(mainView2)
        view.addSubview(stackView)
        mainView2.addSubview(bookSV)
        
        btnStack.addArrangedSubview(shelfyBtn)
        btnStack.addArrangedSubview(readBtn)
        btnStack.addArrangedSubview(buyBtn)
        

        bookSV.addSubview(testView2)
        testView2.addSubview(moreView)
        bookSV.addSubview(testView)
        testView.addSubview(shelfyBtn)
//        descrView.addSubview(descrHeader)
//        descrView.addSubview(descrScroll)
//        descrScroll.addSubview(descrContent)
        
        
                    
        bookImg2.topAnchor.constraint(equalTo: mainView1.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
            bookImg2.centerXAnchor.constraint(equalTo: mainView1.centerXAnchor).isActive = true
            bookImg2.widthAnchor.constraint(equalToConstant: 120).isActive = true
            bookImg2.heightAnchor.constraint(equalToConstant: 220).isActive = true

            bookTitle.topAnchor.constraint(equalTo: bookImg2.bottomAnchor, constant: 10).isActive = true
            bookTitle.centerXAnchor.constraint(equalTo: mainView1.centerXAnchor).isActive = true
            bookAuthor.topAnchor.constraint(equalTo: bookTitle.bottomAnchor, constant: 5).isActive = true
            bookAuthor.centerXAnchor.constraint(equalTo: mainView1.centerXAnchor).isActive = true
        
        btnStack.topAnchor.constraint(equalTo: bookAuthor.bottomAnchor, constant: 15).isActive = true
        btnStack.centerXAnchor.constraint(equalTo: mainView1.centerXAnchor).isActive = true
            
            mainView1.heightAnchor.constraint(equalTo: mainView2.heightAnchor).isActive = true
        mainView2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        mainView2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
            mainView1.widthAnchor.constraint(equalTo: mainView2.widthAnchor).isActive = true

            
            stackView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            
            
            bookSV.topAnchor.constraint(equalTo: mainView2.topAnchor).isActive = true
            bookSV.leadingAnchor.constraint(equalTo: mainView2.leadingAnchor).isActive = true
            bookSV.trailingAnchor.constraint(equalTo: mainView2.trailingAnchor).isActive = true
            bookSV.bottomAnchor.constraint(equalTo: mainView2.bottomAnchor).isActive = true
            
//            descrView.topAnchor.constraint(equalTo: bookSV.topAnchor, constant: 5),
//            descrView.leadingAnchor.constraint(equalTo: bookSV.leadingAnchor, constant: 5),
//            descrView.trailingAnchor.constraint(equalTo: bookSV.trailingAnchor, constant: -5),
//            descrView.bottomAnchor.constraint(equalTo: bookSV.bottomAnchor, constant: -5),
//
//            descrHeader.topAnchor.constraint(equalTo: descrView.topAnchor, constant: 5),
//            descrHeader.leadingAnchor.constraint(equalTo: descrView.leadingAnchor, constant: 5),
//
//            descrScroll.topAnchor.constraint(equalTo: descrHeader.bottomAnchor, constant: 5),
//            descrScroll.leadingAnchor.constraint(equalTo: descrView.leadingAnchor, constant: 3),
//            descrScroll.trailingAnchor.constraint(equalTo: descrView.trailingAnchor, constant: -3),
//            descrScroll.bottomAnchor.constraint(equalTo: descrView.bottomAnchor, constant: -5),
//
//            descrContent.topAnchor.constraint(equalTo: descrScroll.topAnchor),
//            descrContent.leadingAnchor.constraint(equalTo: descrScroll.leadingAnchor),
//            descrContent.trailingAnchor.constraint(equalTo: descrScroll.trailingAnchor),
//            descrContent.bottomAnchor.constraint(equalTo: descrScroll.bottomAnchor),
            
            testView.topAnchor.constraint(equalTo: bookSV.topAnchor).isActive = true
            testView.leadingAnchor.constraint(equalTo: bookSV.leadingAnchor).isActive = true
            testView.trailingAnchor.constraint(equalTo: bookSV.trailingAnchor).isActive = true
            testView.bottomAnchor.constraint(equalTo: bookSV.bottomAnchor).isActive = true
            
        moreView.topAnchor.constraint(equalTo: testView2.topAnchor, constant: 10).isActive = true
        moreView.centerXAnchor.constraint(equalTo: testView2.centerXAnchor).isActive = true
//            bookImg.widthAnchor.constraint(equalToConstant: 120).isActive = true
//            bookImg.heightAnchor.constraint(equalToConstant: 220).isActive = true
            
            shelfyBtn.centerXAnchor.constraint(equalTo: testView.centerXAnchor).isActive = true
            shelfyBtn.centerYAnchor.constraint(equalTo: testView.centerYAnchor).isActive = true
            
            testView2.topAnchor.constraint(equalTo: bookSV.topAnchor).isActive = true
            testView2.leadingAnchor.constraint(equalTo: bookSV.leadingAnchor).isActive = true
            testView2.trailingAnchor.constraint(equalTo: bookSV.trailingAnchor).isActive = true
            testView2.bottomAnchor.constraint(equalTo: bookSV.bottomAnchor).isActive = true
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 {
            scrollView.contentOffset.y = 0
        }
        if scrollView.contentOffset.y < 0 {
            scrollView.contentOffset.y = 0
        }
    }
    
    // Number of items in the collection view
    func collectionView(_ moreView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 25 // Return the number of items you want to display
    }
    
    // Configure the cells
    func collectionView(_ moreView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = moreView.dequeueReusableCell(withReuseIdentifier: "testIdentifier", for: indexPath) as! MoreByCell
        // Customize the cell's content based on the data you have
        cell.titleLabel?.text = "Item \(indexPath.item + 1)"
        //        cell.titleLbl?.text = "Item \(indexPath.item)"
        cell.imageView?.image = UIImage(named: "halo")
        return cell
    }
    
    func collectionView(_ moreView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // When a cell is selected, call the delegate method
        didSelectItem(at: indexPath)
    }
    
}

