//
//  MoreController.swift
//  Shelfy
//
//  Created by Marian Nasturica on 05.06.2023.
//

import UIKit
import Firebase

class MoreController: UIViewController {
    
    let optionLbl = UILabel()
    let darkMode = UISwitch()
    let pageDisplay = UISwitch()
    let signOutBtn = UIButton()
    let darkModeLbl = UILabel()
    let pageDisplayLbl = UILabel()
    
    let myBookViewInstance = MyBookView() // Assuming myBookViewInstance is accessible here
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        optionLbl.translatesAutoresizingMaskIntoConstraints = false
        darkMode.translatesAutoresizingMaskIntoConstraints = false
        signOutBtn.translatesAutoresizingMaskIntoConstraints = false
        pageDisplay.translatesAutoresizingMaskIntoConstraints = false
        darkModeLbl.translatesAutoresizingMaskIntoConstraints = false
        pageDisplayLbl.translatesAutoresizingMaskIntoConstraints = false
        
        optionLbl.font = SetFont.setFontStyle(.medium, 22)
        optionLbl.textColor = UIColor(resource: .textBG)
        optionLbl.text = "Options"
        
        pageDisplayLbl.text = "Pages Display Mode "
        
        darkModeLbl.text = "Dark Mode"
        
        darkMode.isOn = false
        darkMode.addTarget(self, action: #selector(darkModeToggle), for: .valueChanged)
        
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
        view.addSubview(pageDisplayLbl)
        view.addSubview(darkModeLbl)
        
        NSLayoutConstraint.activate([
            
            optionLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            optionLbl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            darkModeLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            darkMode.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            darkMode.topAnchor.constraint(equalTo: optionLbl.bottomAnchor, constant: 40),
            darkMode.centerYAnchor.constraint(equalTo: darkModeLbl.centerYAnchor),
            
            pageDisplayLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            pageDisplay.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            pageDisplay.topAnchor.constraint(equalTo: darkMode.bottomAnchor, constant: 16),
            pageDisplay.centerYAnchor.constraint(equalTo: pageDisplayLbl.centerYAnchor),
            
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
    
    @objc func darkModeToggle(sender: UISwitch) {
        
        if darkMode.isOn {
            darkModeLbl.text = "Light Mode"
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .dark
            }
        } else {
            darkModeLbl.text = "Dark Mode"
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .light
            }        }
        
    }
    
    @objc func togglePageDisplay(sender: UISwitch) {
        
        if pageDisplay.isOn {
            
        } else {
            
        }
        
        
    }
    
    
    func setupMoreView() {
        
        
        
    }
    
}
