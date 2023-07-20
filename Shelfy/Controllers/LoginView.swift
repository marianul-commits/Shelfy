//
//  LoginView.swift
//  Shelfy
//
//  Created by Marian Nasturica on 11.07.2023.
//

import UIKit
import FirebaseAuth

class LoginView: UIViewController {
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var pwdField: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loginBtn.layer.cornerRadius = loginBtn.frame.size.height / 5
        emailConfig()
        passConfig()
        pwdField.enablePasswordToggle()
        
    }
    
    @IBAction func registerPressed(_ sender: Any) {
        self.performSegue(withIdentifier: K.createAccIdentifier, sender: self)
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
