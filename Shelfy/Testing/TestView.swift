//
//  TestView.swift
//  Shelfy
//
//  Created by Marian Nasturica on 11.07.2023.
//

import UIKit

class TestView: UIViewController, UISearchControllerDelegate {
    
    var bView = makeView()
    
    var mainLbl = makeLabel(withText: "Shelfy")
    var mottoLbl = makeLabel(withText: "Your personal bookshelf in your pocket")
    var registerTxt = makeLabel(withText: "Join the Bookworm Brigade!")
//    var registerBtn = makeButton(withTitle: "Register")
//    var dashLbl = makeLabel(withText: "––––––––")
//    var otherLbl = makeLabel(withText: "OR")
    
        
    override func viewDidLoad() {

        setupTest()
    }
    
    func setupTest() {
        
        bView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        bView.translatesAutoresizingMaskIntoConstraints = false
        bView.backgroundColor = .purple
        
        mainLbl.textColor = UIColor(named: "Color2")
        mainLbl.font = SetFont.setFontStyle(.ultra, 40)
        mottoLbl.textColor = UIColor(named: "Color5")
        mottoLbl.font = SetFont.setFontStyle(.regular, 20)
        registerTxt.textColor = UIColor(named: "Color1")
        registerTxt.font = SetFont.setFontStyle(.regular, 17)
//        dashLbl.textColor = UIColor(named: "Color4")
//        otherLbl.textColor = UIColor(named: "Color4")

        
        view.addSubview(bView)
        bView.addSubview(mainLbl)
        bView.addSubview(mottoLbl)
        bView.addSubview(registerTxt)
//        bView.addSubview(registerBtn)
//        bView.addSubview(dashLbl)
//        bView.addSubview(otherLbl)

        
        
        
        bView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        mainLbl.topAnchor.constraint(equalTo: bView.topAnchor, constant: 10).isActive = true
        mainLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mottoLbl.topAnchor.constraint(equalTo: mainLbl.bottomAnchor, constant: 5).isActive = true
        mottoLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registerTxt.topAnchor.constraint(equalTo: mottoLbl.bottomAnchor, constant: 30).isActive = true
        registerTxt.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
        
        
        
        
        
    }
    
    
    }


