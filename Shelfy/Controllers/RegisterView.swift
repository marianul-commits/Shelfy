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
    
    
    @IBOutlet weak var createAccBtn: UIButton!
    
    @IBOutlet weak var emailField: UITextField!
     
    @IBOutlet weak var passField: UITextField!
    
    @IBOutlet weak var passField2: UITextField!
    
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createAccBtn.layer.cornerRadius = createAccBtn.frame.size.height / 5
        
        emailField.delegate = self
        
        passField.delegate = self
        passField.enablePasswordToggle()
        passField2.delegate = self
        passField2.enablePasswordToggle()
        emailConfig()
        passConfig()
        
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
    
    
     func textFieldDidEndEditing(_ textField: UITextField) {
        validateTextFields()
        validateMailField()
        
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { _ in
            self.animateBorderColorChange(textField: self.passField, to: .clear)
            self.animateBorderColorChange(textField: self.passField2, to: .clear)
            self.animateBorderColorChange(textField: self.emailField, to: .clear)
        }
    }
    
    private func showAlertWithSegue() {
        let alertController = UIAlertController(title: "Success", message: "Account created successfully!", preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.performSegue(withIdentifier: K.registerIdentifier, sender: self)
        }
        
        alertController.addAction(dismissAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    private func validateMailField(){
        
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
        let color = UIColor(named: "Color1")
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
        let color = UIColor(named: "Color1")
        let imageView = UIImageView(frame: CGRect(x: 3, y: 2.5, width: 25, height: 25))
        imageView.tintColor = color
        let image = UIImage(systemName: "lock.fill")
        image?.withTintColor(color!)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 30))
        view.addSubview(imageView)
        view.backgroundColor = .clear
        passField.leftViewMode = UITextField.ViewMode.always
        passField.leftView = view
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


