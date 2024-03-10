//
//  RegisterView.swift
//  Shelfy
//
//  Created by Marian Nasturica on 11.07.2023.
//

import UIKit
import FirebaseAuth
//import FirebaseCore
//import Firebase

class RegisterView: UIViewController, UITextFieldDelegate{
    
    var emailField = makeTextField(withPlaceholder: "E-Mail")
    var passField = makeTextField(withPlaceholder: "Password")
    var passField2 = makeTextField(withPlaceholder: "Confirm Password")
    var backBtn = makeImgButton(withImg: "multiply.circle.fill")
    var createAccBtn = makeButtonColor(withTitle: "Create Account", withColor: "brandLogo3")
    var registerMotto = makeLabel(withText: "Embark On Your Reading Journey With Shelfy!")
    var spacerView = makeSpacerView()
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLogin()
        
    }
    
    private func setupLogin() {
        
        
        emailField.delegate = self
        passField.delegate = self
        passField2.delegate = self
        
        passField.isSecureTextEntry = true
        passField2.isSecureTextEntry = true
        
        emailField.frame.size.height = 35
        passField.frame.size.height = 35
        passField2.frame.size.height = 35
        emailField.tintColor = UIColor(resource: .brandDarkMint)
        passField.tintColor = UIColor(resource: .brandDarkMint)
        passField2.tintColor = UIColor(resource: .brandDarkMint)
        
        passField.enablePasswordToggle()
        passField2.enablePasswordToggle()
        
        emailConfig()
        passConfig()
        passConfig2()
        
        backBtn.frame.size.height = 35
        
        registerMotto.textColor = UIColor(resource: .brandLogo3)
        registerMotto.font = SetFont.setFontStyle(.medium, 17)
        
        createAccBtn.addTarget(self, action: #selector(createPressed), for: .touchUpInside)
        backBtn.addTarget(self, action: #selector(backPressed), for: .touchUpInside)
        
        view.addSubview(backBtn)
        view.addSubview(registerMotto)
        view.addSubview(emailField)
        view.addSubview(passField)
        view.addSubview(passField2)
        view.addSubview(createAccBtn)
        view.addSubview(spacerView)
        
        let screenWidth = UIScreen.main.bounds.width

        // Register Lbl Constraints
        registerMotto.topAnchor.constraint(equalTo: backBtn.bottomAnchor, constant: 20).isActive = true
        registerMotto.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        // Spacer View
        spacerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
        spacerView.topAnchor.constraint(equalTo: registerMotto.bottomAnchor).isActive = true
        // Fields Constraints
        emailField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        emailField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        emailField.topAnchor.constraint(equalTo: spacerView.bottomAnchor, constant: 40).isActive = true
        passField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 20).isActive = true
        passField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        passField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        passField2.topAnchor.constraint(equalTo: passField.bottomAnchor, constant: 20).isActive = true
        passField2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        passField2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        // Create Account Btn Constraints
        createAccBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        createAccBtn.topAnchor.constraint(equalTo: passField2.bottomAnchor, constant: 30).isActive = true
        // Back Btn Constraints
        backBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        backBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenWidth * 0.1).isActive = true
    }
    
    @objc func backPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    
    @objc func createPressed() {
        if passField.text == passField2.text {
            
            if let email = emailField.text, let password = passField.text {
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    if let e = error {
                        print(e.localizedDescription)
                        print(e)
                    } else {
                        self.showAlertWithSegue()
                    }
                }
            }
        }
    }
    
     func textFieldDidEndEditing(_ textField: UITextField) {
        validateTextFields()
        validateMailField()
        
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
            self.animateBorderColorChange(textField: self.passField, to: .clear)
            self.animateBorderColorChange(textField: self.passField2, to: .clear)
            self.animateBorderColorChange(textField: self.emailField, to: .clear)
        }
    }
    
     func showAlertWithSegue() {
        let alertController = UIAlertController(title: "Success", message: "Account created successfully!", preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.performSegue(withIdentifier: K.registerIdentifier, sender: self)
        }
        
        alertController.addAction(dismissAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
     func validateMailField(){
        
        let emailText = emailField.text ?? ""
        
        if emailText.contains("@") {
            emailField.layer.borderWidth = 1.5
            animateBorderColorChange(textField: emailField, to: .green)
        } else {
            emailField.layer.borderWidth = 1.5
            animateBorderColorChange(textField: emailField, to: .red)
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
        passField.leftViewMode = UITextField.ViewMode.always
        passField.leftView = view
    }
    
    private func passConfig2() {
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
        passField2.leftViewMode = UITextField.ViewMode.always
        passField2.leftView = view
    }
    
    
    func validateTextFields() {
        let pass1 = passField.text ?? ""
        let pass2 = passField2.text ?? ""
        
        if pass1.isEmpty || pass2.isEmpty {
            passField.layer.borderColor = pass1.isEmpty ? UIColor.red.cgColor : UIColor.gray.cgColor
            passField2.layer.borderColor = pass2.isEmpty ? UIColor.red.cgColor : UIColor.gray.cgColor
        } else if pass1 != pass2 {
            self.animateBorderColorChange(textField: self.passField2, to: .red)
            passField2.layer.borderWidth = 1.5
            addShakeAnimation(to: passField2)
        } else if pass2 != pass1{
            self.animateBorderColorChange(textField: self.passField, to: .red)
            passField.layer.borderWidth = 1.5
            addShakeAnimation(to: passField)
        } else if pass1 == pass2 {
            passField.layer.borderWidth = 1.5
            animateBorderColorChange(textField: passField, to: .green)
            passField2.layer.borderWidth = 1.5
            animateBorderColorChange(textField: passField2, to: .green)
        }
    }
    
     func addShakeAnimation(to textField: UITextField) {
        let shakeAnimation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        shakeAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        shakeAnimation.duration = 0.6
        shakeAnimation.values = [-10, 10, -10, 10, -5, 5, -2, 2, 0]
        textField.layer.add(shakeAnimation, forKey: "shakeAnimation")
    }
    
     func animateBorderColorChange(textField: UITextField, to color: UIColor) {
        UIView.animate(withDuration: 0.3) {
            textField.layer.borderColor = color.cgColor
        }
    }
    
}


