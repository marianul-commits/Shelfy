//
//  TestView.swift
//  Shelfy
//
//  Created by Marian Nasturica on 11.07.2023.
//

import UIKit

class TestView: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var menuBtn: UIButton!
    
    override func viewDidLoad() {
            super.viewDidLoad()

            setMenuBtn()
        textField.enablePasswordToggle()

        }

    
    func setMenuBtn() {
        
        let optionClosure = {(action: UIAction) in
            print(action.title)
        }
        
        menuBtn.menu = UIMenu(children: [
            UIAction(title: "Want To Read", state: .on, handler: optionClosure),
            UIAction(title: "Have Read", handler: optionClosure),
            UIAction(title: "Favorite", handler: optionClosure),
        ])
        
        menuBtn.showsMenuAsPrimaryAction = true
        if #available(iOS 15.0, *) {
            menuBtn.changesSelectionAsPrimaryAction = true
        } else {
            // Fallback on earlier versions
        }
    }
    
}

extension UITextField {
fileprivate func setPasswordToggleImage(_ button: UIButton) {
    if(isSecureTextEntry){
        button.setImage(UIImage(systemName: "eye.slash.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.black), for: .normal)
    }else{
        button.setImage(UIImage(systemName: "eye.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.black), for: .normal)

    }
}

func toggPwd(){
    let button = UIButton(type: .custom)
    setPasswordToggleImage(button)
    button.tintColor = UIColor(named: "Color1")
    button.backgroundColor = UIColor(named: "Color1")
    button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
    button.frame = CGRect(x: CGFloat(self.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
    button.addTarget(self, action: #selector(self.togglePasswordView), for: .touchUpInside)
    self.rightView = button
    self.rightViewMode = .always
}
@IBAction func toggPwdView(_ sender: Any) {
    self.isSecureTextEntry = !self.isSecureTextEntry
    setPasswordToggleImage(sender as! UIButton)
}
}
