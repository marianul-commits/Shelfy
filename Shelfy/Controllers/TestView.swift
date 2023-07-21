//
//  TestView.swift
//  Shelfy
//
//  Created by Marian Nasturica on 11.07.2023.
//

import UIKit

class TestView: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var textF: UITextField!

       override func viewDidLoad() {
           super.viewDidLoad()
           textF.delegate = self
           textF.isHidden = true
           lbl.font = SetFont.setFontStyle(.light, 16)
       }

    @IBAction func editTap(_ sender: Any) {
        lbl.isHidden = true
        textF.isHidden = false
        textF.text = lbl.text
        print("user started editing")
        
//        func textFieldShouldReturn(userText: UITextField) {
//            userText.resignFirstResponder()
//            textF.isHidden = true
//            lbl.isHidden = false
//            lbl.text = textF.text
//            print("user resigned editing")
//        }
    }
    
    
    func lblTapped(){
//           lbl.isHidden = true
//           textF.isHidden = false
//           textF.text = lbl.text
           print("label tapped")
       }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textF.resignFirstResponder()
        textF.isHidden = true
        lbl.isHidden = false
        lbl.text = textF.text
    }

//       func textFieldShouldReturn(userText: UITextField) -> Bool {
//           userText.resignFirstResponder()
//           textF.isHidden = true
//           lbl.isHidden = false
//           lbl.text = textF.text
//           return true
//       }
   }

