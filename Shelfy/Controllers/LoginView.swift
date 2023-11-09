//
//  LoginView.swift
//  Shelfy
//
//  Created by Marian Nasturica on 11.07.2023.
//

import UIKit
import FirebaseAuth

class LoginView: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var pwdField: UITextField!
    var mainLbl = makeLabel(withText: "Shelfy")
    var mottoLbl = makeLabel(withText: "Your personal bookshelf in your pocket")
    var registerTxt = makeLabel(withText: "Join the Bookworm Brigade!")
    var dashLbl = makeLabel(withText: "–––––––––––––")
    var dashLbl2 = makeLabel(withText: "–––––––––––––")
    var otherLbl = makeLabel(withText: "OR")
    var stack = makeStackView(withOrientation: .horizontal, withSpacing: 3.0)
    let loginBtn = makeButton(withTitle: "Login")
    let spacerView = makeSpacerView(height: 100)
    let registerBtn = makeButton2(withTitle: "Register")
    let textStack = makeStackView(withOrientation: .horizontal, withSpacing: 0.5)

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loginBtn.layer.cornerRadius = loginBtn.frame.size.height / 5
        emailConfig()
        passConfig()
        pwdField.enablePasswordToggle()
        setupLogin()
        
    }
    
    @IBAction func loginPressed(_ sender: Any) {
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
    
    private func setupLogin() {
        
        mainLbl.textColor = UIColor(named: "Color2")
        mainLbl.font = SetFont.setFontStyle(.ultra, 40)
        mottoLbl.textColor = UIColor(named: "Color5")
        mottoLbl.font = SetFont.setFontStyle(.regular, 20)
        registerTxt.textColor = UIColor(named: "Color1")
        registerTxt.font = SetFont.setFontStyle(.regular, 17)
        dashLbl.textColor = UIColor(named: "Color4")
        dashLbl.font = SetFont.setFontStyle(.bold, 15)
        dashLbl2.textColor = UIColor(named: "Color4")
        dashLbl2.font = SetFont.setFontStyle(.bold, 15)
        otherLbl.textColor = UIColor(named: "Color4")
        otherLbl.font = SetFont.setFontStyle(.regular, 15)
        loginBtn.frame.size = CGSize(width: 200, height: 35)
        spacerView.frame.size = CGSize(width: 150, height: 250)
        registerBtn.backgroundColor = .clear
        
        view.addSubview(mainLbl)
        view.addSubview(mottoLbl)
        view.addSubview(textStack)
        view.addSubview(stack)
        view.addSubview(loginBtn)
        view.addSubview(spacerView)
        view.addSubview(registerBtn)
        stack.addArrangedSubview(dashLbl)
        stack.addArrangedSubview(otherLbl)
        stack.addArrangedSubview(dashLbl2)
        textStack.addArrangedSubview(registerTxt)
        textStack.addArrangedSubview(registerBtn)


        mainLbl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        mainLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mottoLbl.topAnchor.constraint(equalTo: mainLbl.bottomAnchor, constant: 5).isActive = true
        mottoLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spacerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25).isActive = true
        emailField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        emailField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        emailField.topAnchor.constraint(equalTo: spacerView.bottomAnchor, constant: 40).isActive = true
        pwdField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 20).isActive = true
        pwdField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        pwdField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        loginBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginBtn.topAnchor.constraint(equalTo: pwdField.bottomAnchor, constant: 30).isActive = true
        textStack.topAnchor.constraint(equalTo: loginBtn.bottomAnchor, constant: 40).isActive = true
        textStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        textStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        stack.topAnchor.constraint(equalTo: textStack.bottomAnchor, constant: 20).isActive = true
        stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true

        
        
        
    }
    
    
    private func emailConfig() {
        let color = UIColor(named: "Accent")
        let imageView = UIImageView(frame: CGRect(x: 3, y: 2.5, width: 25, height: 25))
        imageView.tintColor = color
        let image = UIImage(systemName: "envelope.fill")
        image?.withTintColor(color!)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 30))
        view.addSubview(imageView)
        view.backgroundColor = .clear
        emailField.leftViewMode = UITextField.ViewMode.always
        emailField.leftView = view
    }
    
    private func passConfig() {
        let color = UIColor(named: "Accent")
        let imageView = UIImageView(frame: CGRect(x: 3, y: 2.5, width: 25, height: 25))
        imageView.tintColor = color
        let image = UIImage(systemName: "lock.fill")
        image?.withTintColor(color!)
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
        button.setImage(UIImage(systemName: "eye.slash.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(UIColor(named: "Accent")!), for: .normal)
    }else{
        button.setImage(UIImage(systemName: "eye.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(UIColor(named: "Accent")!), for: .normal)

    }
}

 func enablePasswordToggle(){
    let button = UIButton(type: .custom)
    setPasswordToggleImage(button)
    button.tintColor = UIColor(named: "Accent")
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
