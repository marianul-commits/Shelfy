//
//  RegisterView.swift
//  Shelfy
//
//  Created by Marian Nasturica on 11.07.2023.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import Firebase

class RegisterView: UIViewController, UITextFieldDelegate{
    
    
    @IBOutlet weak var showPass1: UIButton!
    @IBOutlet weak var showPass2: UIButton!
    
    @IBOutlet weak var createAccBtn: UIButton!
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passField: UITextField!
    
    @IBOutlet weak var passField2: UITextField!
    
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createAccBtn.layer.cornerRadius = createAccBtn.frame.size.height / 5
        
        passField.delegate = self
        passField2.delegate = self
        
    }
    
    @IBAction func createAcc(_ sender: Any) {
        
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
    
    @IBAction func showPass1Pressed(_ sender: Any) {
        
        passField.isSecureTextEntry.toggle()
        
        if passField.isSecureTextEntry == true {
            showPass1.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        } else {
            showPass1.setImage(UIImage(systemName: "eye"), for: .normal)
        }
        
    }
    
    @IBAction func showPass2Pressed(_ sender: Any) {
        
        passField2.isSecureTextEntry.toggle()
        
        if passField2.isSecureTextEntry == true {
            showPass2.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        } else {
            showPass2.setImage(UIImage(systemName: "eye"), for: .normal)
        }
        
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        validateTextFields()
        
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { _ in
            self.animateBorderColorChange(textField: self.passField, to: .clear)
            self.animateBorderColorChange(textField: self.passField2, to: .clear)
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
        } else {
            self.animateBorderColorChange(textField: self.passField, to: .red)
            passField.layer.borderWidth = 1.5
            addShakeAnimation(to: passField)
            
        }
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


