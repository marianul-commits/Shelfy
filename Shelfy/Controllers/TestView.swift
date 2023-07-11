//
//  TestView.swift
//  Shelfy
//
//  Created by Marian Nasturica on 11.07.2023.
//

import UIKit

class TestView: UIViewController {
    
        
    @IBOutlet weak var menuBtn: UIButton!
    
    override func viewDidLoad() {
            super.viewDidLoad()

            setMenuBtn()

        }

    
    func setMenuBtn() {
        
        let optionClosure = {(action: UIAction) in
            print(action.title)
        }
        
        menuBtn.menu = UIMenu(children: [
            UIAction(title: "Want To Read", state: .on, handler: optionClosure),
            UIAction(title: "Read", handler: optionClosure)])
        
        menuBtn.showsMenuAsPrimaryAction = true
        if #available(iOS 15.0, *) {
            menuBtn.changesSelectionAsPrimaryAction = true
        } else {
            // Fallback on earlier versions
        }
    }
    
}
