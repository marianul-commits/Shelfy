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
    var dashLbl = UIView()
    let loginBtn = makeButton(withTitle: "Login")
    let spacerView = makeSpacerView(height: 40)
    let registerBtn = makeButton2(withTitle: "Register")
    let continueAsGuest = makeButton2(withTitle: "Continue as Guest!")
    var timer: Timer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupLogin()
        
    }
    
    private func setupLogin() {
        
        view.backgroundColor = UIColor(resource: .background)
        
        emailConfig()
        passConfig()
        pwdField.enablePasswordToggle()
        
        mainLbl.textColor = UIColor(resource: .brandLogo)
        mainLbl.font = SetFont.setFontStyle(.ultra, 40)
        mottoLbl.textColor = UIColor(resource: .brandLogo3)
        mottoLbl.font = SetFont.setFontStyle(.regular, 20)
        
        pwdField.isSecureTextEntry = true
        emailField.frame.size.height = 35
        pwdField.frame.size.height = 35
        emailField.tintColor = UIColor(resource: .brandMint)
        pwdField.tintColor = UIColor(resource: .brandMint)
        
        registerTxt.textColor = UIColor(resource: .brandLogo2)
        registerTxt.font = SetFont.setFontStyle(.regular, 17)
        
        dashLbl.translatesAutoresizingMaskIntoConstraints = false
        dashLbl.backgroundColor = UIColor(resource: .brandGray)
        
        loginBtn.frame.size = CGSize(width: 200, height: 35)
        loginBtn.tintColor = UIColor(resource: .brandLogo)
        
        registerBtn.tintColor = UIColor(resource: .brandLogo2)
        registerBtn.titleLabel?.numberOfLines = 1
        
        continueAsGuest.tintColor = UIColor(resource: .brandLogo3)
        continueAsGuest.titleLabel?.numberOfLines = 1
                
        loginBtn.addTarget(self, action: #selector(loginPressed), for: .touchUpInside)
        registerBtn.addTarget(self, action: #selector(registerPressed), for: .touchUpInside)
        continueAsGuest.addTarget(self, action: #selector(continuePressed), for: .touchUpInside)

        
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
        view.addSubview(continueAsGuest)
        
        let screenWidth = UIScreen.main.bounds.width

        NSLayoutConstraint.activate([
        
        // Main Lbl Constraints
        mainLbl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
        mainLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        // Motto Constraints
        mottoLbl.topAnchor.constraint(equalTo: mainLbl.bottomAnchor, constant: 5),
        mottoLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        // Spacer View
        spacerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
        spacerView.topAnchor.constraint(equalTo: mottoLbl.bottomAnchor),
        // Fields Constraints
        emailField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        emailField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        emailField.topAnchor.constraint(equalTo: spacerView.bottomAnchor, constant: 40),
        pwdField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 20),
        pwdField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        pwdField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        // Login Btn Constraints
        loginBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        loginBtn.topAnchor.constraint(equalTo: pwdField.bottomAnchor, constant: 30),
        // Register Btn Constraints
        registerBtn.topAnchor.constraint(equalTo: loginBtn.bottomAnchor, constant: 40),
        registerBtn.leadingAnchor.constraint(equalTo: registerTxt.trailingAnchor, constant: 4),
        registerBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenWidth * 0.1),
        registerBtn.centerYAnchor.constraint(equalTo: registerTxt.centerYAnchor),
        // Register Text Constraints
        registerTxt.topAnchor.constraint(equalTo: registerBtn.topAnchor),
        registerTxt.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenWidth * 0.1),
        // Login with Constraints
        dashLbl.topAnchor.constraint(equalTo: registerTxt.bottomAnchor, constant: 20),
        dashLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        dashLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        dashLbl.heightAnchor.constraint(equalToConstant: 1),
        // Continue Constraints
        continueAsGuest.topAnchor.constraint(equalTo: dashLbl.bottomAnchor, constant: 20),
        continueAsGuest.centerXAnchor.constraint(equalTo: view.centerXAnchor),

        ])
    }
    
    @objc private func registerPressed() {
        performSegue(withIdentifier: "registerPressed", sender: nil)
    }
    
    
    @objc private func loginPressed() {
        if let email = emailField.text, let password = pwdField.text{
        
                Auth.auth().signIn(withEmail: email, password: password) {authResult, error in
                    if let e = error {
                        print(e)
                            self.addShakeAnimation(to: self.emailField)
                            self.animateBorderColorChange(textField: self.emailField, to: .red)
                            self.addShakeAnimation(to: self.pwdField)
                            self.animateBorderColorChange(textField: self.pwdField, to: .red)
                    } else {
                        UserDefaults.standard.set(true, forKey: "isLoggedIn")
                        UserDefaults.standard.synchronize()
                        
                        let loginVC = TabBarViewController()
                        loginVC.selectedIndex = 0
                        loginVC.modalPresentationStyle = .fullScreen
                        self.present(loginVC, animated: true, completion: nil)
                    }
                }
        }
    }
    
    @objc private func continuePressed() {
        let guestModeVC = TabBarViewController()
        guestModeVC.selectedIndex = 0
        guestModeVC.modalPresentationStyle = .fullScreen
        present(guestModeVC, animated: true, completion: nil)
    }
    
    private func textFieldDidEndEditing(_ textField: UITextField) {
       
       timer?.invalidate()
       
       timer = Timer.scheduledTimer(withTimeInterval: 1.25, repeats: false) { _ in
           self.animateBorderColorChange(textField: self.pwdField, to: .clear)
           self.animateBorderColorChange(textField: self.emailField, to: .clear)
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
    
    private func addShakeAnimation(to textField: UITextField) {
       let shakeAnimation = CAKeyframeAnimation(keyPath: "transform.translation.x")
       shakeAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
       shakeAnimation.duration = 0.6
       shakeAnimation.values = [-10, 10, -10, 10, -5, 5, -2, 2, 0]
       textField.layer.add(shakeAnimation, forKey: "shakeAnimation")
   }
   
    private func animateBorderColorChange(textField: UITextField, to color: UIColor) {
       UIView.animate(withDuration: 0.3) {
           textField.layer.borderColor = color.cgColor
       }
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
