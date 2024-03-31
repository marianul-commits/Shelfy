//
//  MoreController.swift
//  Shelfy
//
//  Created by Marian Nasturica on 05.06.2023.
//

import UIKit
import Firebase

class MoreController: UIViewController {
    
    let optionHeader = UILabel()
    let themeSwitch = UISwitch()
    let themeLabel = UILabel()
    let pageStyle = UISwitch()
    let pageStyleLabel = UILabel()
    let signOutBtn = UIButton()
    let userLoginStatus = UserDefaults.standard.bool(forKey: "isLoggedIn")
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        themeSwitch.isOn = UserDefaults.standard.bool(forKey: "themeSwitch")
        pageStyle.isOn = UserDefaults.standard.bool(forKey: "pageSwitch")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        optionHeader.translatesAutoresizingMaskIntoConstraints = false
        themeSwitch.translatesAutoresizingMaskIntoConstraints = false
        signOutBtn.translatesAutoresizingMaskIntoConstraints = false
        pageStyle.translatesAutoresizingMaskIntoConstraints = false
        themeLabel.translatesAutoresizingMaskIntoConstraints = false
        pageStyleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        optionHeader.font = SetFont.setFontStyle(.medium, 22)
        optionHeader.textColor = UIColor(resource: .textBG)
        optionHeader.text = "Options"
        
        pageStyleLabel.text = "Pages Display Mode "
        pageStyle.addTarget(self, action: #selector(togglePageDisplay), for: .valueChanged)
        
        themeLabel.text = "Dark Mode"
        themeSwitch.addTarget(self, action: #selector(themeToggle), for: .valueChanged)
        
        
        if userLoginStatus {
            signOutBtn.setTitle("Sign Out", for: .normal)
            if #available(iOS 15.0, *) {
                var config = UIButton.Configuration.filled()
                config.cornerStyle = .capsule
                config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 10)
                config.baseBackgroundColor = .red
                signOutBtn.configuration = config
            } else {
                signOutBtn.layer.cornerRadius = 20
                signOutBtn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
                signOutBtn.backgroundColor = .red
                signOutBtn.tintColor = .black
            }
            signOutBtn.addTarget(self, action: #selector(signOut), for: .touchUpInside)
        } else {
            signOutBtn.setTitle("Log In", for: .normal)
            if #available(iOS 15.0, *) {
                var config = UIButton.Configuration.filled()
                config.cornerStyle = .capsule
                config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 10)
                config.baseBackgroundColor = UIColor(resource: .brandLogo)
                signOutBtn.configuration = config
            } else {
                signOutBtn.layer.cornerRadius = 20
                signOutBtn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
                signOutBtn.backgroundColor = UIColor(resource: .brandLogo)
                signOutBtn.tintColor = .black
            }
            signOutBtn.addTarget(self, action: #selector(logIn), for: .touchUpInside)
        }
        
        view.addSubview(optionHeader)
        view.addSubview(themeSwitch)
        view.addSubview(pageStyle)
        view.addSubview(signOutBtn)
        view.addSubview(pageStyleLabel)
        view.addSubview(themeLabel)
        
        NSLayoutConstraint.activate([
            
            optionHeader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            optionHeader.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            themeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            themeSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            themeSwitch.topAnchor.constraint(equalTo: optionHeader.bottomAnchor, constant: 40),
            themeSwitch.centerYAnchor.constraint(equalTo: themeLabel.centerYAnchor),
            
            pageStyleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            pageStyle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            pageStyle.topAnchor.constraint(equalTo: themeSwitch.bottomAnchor, constant: 16),
            pageStyle.centerYAnchor.constraint(equalTo: pageStyleLabel.centerYAnchor),
            
            signOutBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            signOutBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
        ])
        
    }
    
    @objc func signOut(sender: UIButton) {
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        UserDefaults.standard.synchronize()
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            let loginVC = LoginView()
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: true, completion: nil)
            
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
        
    @objc func logIn(sender: UIButton) {
        let loginVC = LoginView()
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true, completion: nil)
    }
    
    @objc func themeToggle(sender: UISwitch) {
        
        if themeSwitch.isOn {
            themeLabel.text = "Light Mode"
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .dark
            }
        } else {
            themeLabel.text = "Dark Mode"
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .light
            }
        }
        UserDefaults.standard.set(themeSwitch.isOn, forKey: "themeSwitch")
        UserDefaults.standard.synchronize()
    }
    
    @objc func togglePageDisplay(sender: UISwitch) {
        let progressLogic = PageStyleManager.shared

        if pageStyle.isOn {
            progressLogic.isPercentageDisplay = true
        } else {
            progressLogic.isPercentageDisplay = false
        }
        UserDefaults.standard.setValue(pageStyle.isOn, forKey: "pageSwitch")
        UserDefaults.standard.synchronize()
    }
    
    
    func setupMoreView() {
        
        
        
    }
    
}
