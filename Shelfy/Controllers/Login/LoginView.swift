//
//  LoginView.swift
//  Shelfy
//
//  Created by Marian Nasturica on 11.07.2023.
//

import UIKit
import FirebaseAuth

class LoginView: UIViewController {
    
    var emailField = makeTextField(withPlaceholder: "E-Mail")
    var pwdField = makeTextField(withPlaceholder: "Password")
    var mainLbl = makeLabel(withText: "Shelfy")
    var mottoLbl = makeLabel(withText: "Your personal bookshelf in your pocket")
    var registerTxt = makeLabel(withText: "Join the Bookworm Brigade!")
    var dashLbl = makeLabel(withText: "––––––––––––")
    var dashLbl2 = makeLabel(withText: "––––––––––––")
    var otherLbl = makeLabel(withText: "OR")
    let loginBtn = makeButton(withTitle: "Login")
    let spacerView = makeSpacerView(height: 40)
    let registerBtn = makeButton2(withTitle: "Register")
//    let textStack = makeStackView(withOrientation: .horizontal, withSpacing: 0.5)

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupLogin()
        
    }
    
    private func setupLogin() {
        
        emailConfig()
        passConfig()
        pwdField.enablePasswordToggle()
        
        mainLbl.textColor = UIColor(named: "Color2")
        mainLbl.font = SetFont.setFontStyle(.ultra, 40)
        mottoLbl.textColor = UIColor(named: "Color5")
        mottoLbl.font = SetFont.setFontStyle(.regular, 20)
        
        pwdField.isSecureTextEntry = true
        emailField.frame.size.height = 35
        pwdField.frame.size.height = 35
        emailField.tintColor = UIColor(named: "Color1")
        pwdField.tintColor = UIColor(named: "Color1")
        
        registerTxt.textColor = UIColor(named: "Color4")
        registerTxt.font = SetFont.setFontStyle(.regular, 17)
        dashLbl.textColor = UIColor(named: "Color4")
        dashLbl.font = SetFont.setFontStyle(.bold, 15)
        dashLbl2.textColor = UIColor(named: "Color4")
        dashLbl2.font = SetFont.setFontStyle(.bold, 15)
        otherLbl.textColor = UIColor(named: "Color4")
        otherLbl.font = SetFont.setFontStyle(.regular, 15)
        loginBtn.frame.size = CGSize(width: 200, height: 35)
        registerBtn.backgroundColor = .clear
        registerBtn.titleLabel?.numberOfLines = 1
        dashLbl.numberOfLines = 1
        otherLbl.numberOfLines = 1
        dashLbl2.numberOfLines = 1
        loginBtn.addTarget(self, action: #selector(loginPressed), for: .touchUpInside)
        registerBtn.addTarget(self, action: #selector(registerPressed), for: .touchUpInside)

        
        view.addSubview(mainLbl)
        view.addSubview(mottoLbl)
        view.addSubview(emailField)
        view.addSubview(pwdField)
        view.addSubview(registerBtn)
        view.addSubview(registerTxt)
        view.addSubview(loginBtn)
        view.addSubview(spacerView)
        view.addSubview(registerBtn)
        view.addSubview(dashLbl)
        view.addSubview(otherLbl)
        view.addSubview(dashLbl2)
        
        let screenWidth = UIScreen.main.bounds.width

        // Main Lbl Constraints
        mainLbl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        mainLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        // Motto Constraints
        mottoLbl.topAnchor.constraint(equalTo: mainLbl.bottomAnchor, constant: 5).isActive = true
        mottoLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        // Spacer View
        spacerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
        spacerView.topAnchor.constraint(equalTo: mottoLbl.bottomAnchor).isActive = true
        // Fields Constraints
        emailField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        emailField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        emailField.topAnchor.constraint(equalTo: spacerView.bottomAnchor, constant: 40).isActive = true
        pwdField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 20).isActive = true
        pwdField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        pwdField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        // Login Btn Constraints
        loginBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginBtn.topAnchor.constraint(equalTo: pwdField.bottomAnchor, constant: 30).isActive = true
        // Register Btn Constraints
        registerBtn.topAnchor.constraint(equalTo: loginBtn.bottomAnchor, constant: 40).isActive = true
        registerBtn.leadingAnchor.constraint(equalTo: registerTxt.trailingAnchor, constant: 4).isActive = true
        registerBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenWidth * 0.1).isActive = true
        registerBtn.centerYAnchor.constraint(equalTo: registerTxt.centerYAnchor).isActive = true
        // Register Text Constraints
        registerTxt.topAnchor.constraint(equalTo: registerBtn.topAnchor).isActive = true
        registerTxt.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenWidth * 0.1).isActive = true
        // Login with Constraints
        dashLbl.topAnchor.constraint(equalTo: registerTxt.bottomAnchor, constant: 20).isActive = true
        dashLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenWidth * 0.15).isActive = true
        dashLbl.trailingAnchor.constraint(equalTo: otherLbl.leadingAnchor, constant: -20).isActive = true
        otherLbl.topAnchor.constraint(equalTo: registerTxt.bottomAnchor, constant: 20).isActive = true
        otherLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dashLbl2.topAnchor.constraint(equalTo: registerTxt.bottomAnchor, constant: 20).isActive = true
        dashLbl2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenWidth * 0.15).isActive = true

    }
    
    @objc func registerPressed() {
        performSegue(withIdentifier: "registerPressed", sender: nil)
    }
    
    
    @objc func loginPressed() {
        if let email = emailField.text, let password = pwdField.text{
        
                Auth.auth().signIn(withEmail: email, password: password) {authResult, error in
                    if let e = error {
                        print(e)
                    } else {
                        self.performSegue(withIdentifier: K.loginIdentifier, sender: self)
                    }
                }
        }
    }
    
    private func emailConfig() {
        let color = UIColor(resource: .brandMint)
        let imageView = UIImageView(frame: CGRect(x: 3, y: 2.5, width: 25, height: 25))
        imageView.tintColor = color
        let image = UIImage(systemName: "envelope.fill")
        image?.withTintColor(color)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 30))
        view.addSubview(imageView)
        view.backgroundColor = .clear
        emailField.leftViewMode = UITextField.ViewMode.always
        emailField.leftView = view
    }
    
    private func passConfig() {
        let color = UIColor(resource: .brandMint)
        let imageView = UIImageView(frame: CGRect(x: 3, y: 2.5, width: 25, height: 25))
        imageView.tintColor = color
        let image = UIImage(systemName: "lock.fill")
        image?.withTintColor(color)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 30))
        view.addSubview(imageView)
        view.backgroundColor = .clear
        pwdField.leftViewMode = UITextField.ViewMode.always
        pwdField.leftView = view
    }
    
    
    
}

// Toggle Password display button

extension UITextField {
fileprivate func setPasswordToggleImage(_ button: UIButton) {
    if(isSecureTextEntry){
        button.setImage(UIImage(systemName: "eye.slash.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(UIColor(resource: .brandMint)), for: .normal)
    }else{
        button.setImage(UIImage(systemName: "eye.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(UIColor(resource: .brandMint)), for: .normal)

    }
}

 func enablePasswordToggle(){
    let button = UIButton(type: .custom)
    setPasswordToggleImage(button)
     button.tintColor = UIColor(resource: .brandMint)
    button.backgroundColor = .clear
    button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
    button.frame = CGRect(x: CGFloat(self.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
    button.addTarget(self, action: #selector(self.togglePasswordView), for: .touchUpInside)
    self.rightView = button
    self.rightViewMode = .always
}
@IBAction func togglePasswordView(_ sender: Any) {
    self.isSecureTextEntry = !self.isSecureTextEntry
    setPasswordToggleImage(sender as! UIButton)
}
}
