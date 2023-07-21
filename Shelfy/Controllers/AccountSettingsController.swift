//
//  AccountSettingsController.swift
//  Shelfy
//
//  Created by Marian Nasturica on 22.07.2023.
//

import UIKit

class AccountSettingsController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var nameTxtF: UITextField!
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        profilePhoto.layer.cornerRadius = profilePhoto.frame.height/2
        nameTxtF.delegate = self
        nameTxtF.isHidden = true
        nameLbl.font = SetFont.setFontStyle(.light, 16)
        
//        darkenView(profileView, withAlpha: 0.3)
        profileView.layer.cornerRadius = profileView.frame.height / 25

    }
    
    
    @IBAction func editPressed(_ sender: Any) {
        nameLbl.isHidden = true
        nameTxtF.isHidden = false
        nameTxtF.text = nameLbl.text
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        nameTxtF.resignFirstResponder()
        nameTxtF.isHidden = true
        nameLbl.isHidden = false
        nameLbl.text = nameTxtF.text
    }
    
    func darkenView(_ view: UIView, withAlpha alpha: CGFloat) {
        let overlayView = UIView(frame: view.bounds)
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(alpha)
        view.addSubview(overlayView)
    }
    
}
