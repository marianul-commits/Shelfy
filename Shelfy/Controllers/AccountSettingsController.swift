//
//  AccountSettingsController.swift
//  Shelfy
//
//  Created by Marian Nasturica on 22.07.2023.
//

import UIKit
import Firebase

class AccountSettingsController: UIViewController {
    
    let optionLbl = UILabel()
    let darkMode = UISwitch()
    let pageDisplay = UISwitch()
    let signOutBtn = UIButton()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        optionLbl.translatesAutoresizingMaskIntoConstraints = false
        darkMode.translatesAutoresizingMaskIntoConstraints = false
        signOutBtn.translatesAutoresizingMaskIntoConstraints = false
        
        optionLbl.font = SetFont.setFontStyle(.medium, 22)
        optionLbl.textColor = UIColor(resource: .textBG)
        optionLbl.text = "Options"
        
        darkMode.isOn = false
        
        pageDisplay.isOn = false
        
        signOutBtn.setTitle("Sign Out", for: .normal)
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.filled()
            config.cornerStyle = .capsule
            config.contentInsets = NSDirectionalEdgeInsets(top: 7, leading: 5, bottom: 7, trailing: 5)
            config.baseBackgroundColor = .red
            signOutBtn.configuration = config
            signOutBtn.addTarget(self, action: #selector(signOut), for: .touchUpInside)
        } else {
            signOutBtn.layer.cornerRadius = 20
            signOutBtn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
            signOutBtn.backgroundColor = .red
            signOutBtn.tintColor = .black
            signOutBtn.addTarget(self, action: #selector(signOut), for: .touchUpInside)
        }
        
        view.addSubview(optionLbl)
        view.addSubview(darkMode)
        view.addSubview(pageDisplay)
        view.addSubview(signOutBtn)
        
    }
    
    @objc func signOut(sender: UIButton) {
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        UserDefaults.standard.synchronize()
        
        let loginVC = LoginView()
        loginVC.view.backgroundColor = UIColor(resource: .background)
        loginVC.modalPresentationStyle = .overFullScreen
        present(loginVC, animated: true, completion: nil)
        
        
    }
        
}
