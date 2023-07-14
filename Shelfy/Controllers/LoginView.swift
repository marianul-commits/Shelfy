//
//  LoginView.swift
//  Shelfy
//
//  Created by Marian Nasturica on 11.07.2023.
//

import UIKit
import FirebaseAuth

class LoginView: UIViewController {
    
    @IBOutlet weak var showPass: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var pwdField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginBtn.layer.cornerRadius = loginBtn.frame.size.height / 5
        
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
    
    @IBAction func showPassPressed(_ sender: Any) {
        
        pwdField.isSecureTextEntry.toggle()
        
        if pwdField.isSecureTextEntry == true {
            showPass.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        } else {
            showPass.setImage(UIImage(systemName: "eye"), for: .normal)
        }
        
    }
    
    
    
}
